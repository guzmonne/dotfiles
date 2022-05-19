#!/usr/bin/env bash

CURRENT_CLUSTER=""
CURRENT_ACCOUNT=""

# Helper functions.
green() {
  printf "${FG_GREEN}${FS_REG}$@${RESET_ALL}"
}

yellow() {
  printf "${FG_YELLOW}${FS_REG}$@${RESET_ALL}"
}

red() {
  printf "${FG_RED}${FS_REG}$@${RESET_ALL}"
}

# This function connects to a Kubernetes cluster and stores the previously connected cluster.
# You can use the return value of this function with the _reconnect_to_cluster function to go
# back to the previous cluster
#
# Args
# ----
#
# 1. environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
_connect_to_cluster() {
  echo $(green "Saving reference to current cluster")
  CURRENT_CLUSTER=$(kubectl config get-contexts | grep -E "^\*" | awk '{print $2}')
  echo $CURRENT_CLUSTER

  echo $(green "Connecting to the") $(yellow $1) $(green "Kubernetes Cluster")
  kubectl config use-context $(kubectl config get-contexts | grep $1 | awk '{print $2}') | grep $1
  echo $CURRENT_CLUSTER
}

# Recconect to the previous cluster stored on the CURRENT_CLUSTER varible.
#
# **Important**: You need to run _connect_to_cluster before running this function for something to
#                happen.
_reconnect_to_cluster() {
  echo $(green "Restablishing previous cluster connection")
  if [ -z "$CURRENT_CLUSTER" ]; then
    kubeclr
  else
    kubectl config use-context $CURRENT_CLUSTER
  fi
}


_save_current_account() {
  echo $(green "Saving reference to current gcloud account")
  CURRENT_ACCOUNT=$(gcloud config configurations list | grep True | awk '{print $1}')
  echo $CURRENT_ACCOUNT

  echo $(green "Connecting to the correct google cloud account")
  gcloud config configurations activate $1 | grep $1
}

_restablish_previous_account() {
  echo $(green "Restablishing previous account connection")
  if [ ! -z "$CURRENT_ACCOUNT" ]; then
    gcloud config configurations activate $CURRENT_ACCOUNT
  fi
}

_check_vpn() {
# Check if we are connected to the VPN
  public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
  if [ "$public_ip" != "144.202.120.51" ]; then
    echo $(red "You need to be connected to the VPN to run this command")
    exit 1
  fi
}

_get_postgres_creds() {
  echo $(green "Getting PostgreSQL credentials for the") $(yellow $1) $(green cluster)
  if [ "$1" == "production" ]; then
    secret="postgres-secret"
    export PGUSER=vntana
  else
    secret="core-postgres-secret"
    export PGUSER=core
  fi
  export PGPASSWORD=$(kubectl -n $1 get secret/"$secret" -o json | jq '.data.password' -r | base64 --decode)
  export PGHOST=$(gcloud sql instances describe $(gcloud sql instances list --format=json | jq -r '.[0].name') --format=json | jq '.ipAddresses[0].ipAddress' -r)
  export PGPORT=5432
  export PGDATABASE=vntana
  env | grep PG
}

# Runs the thumbnail regeneration task by connecting to the admin-gateway service and hitting
# an endpoint exposed by the asset service.
#
# Args
# ----
#
# 1. environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# 2. uuid Organization UUID.
_thumbnail_uuid() {
  echo $2
  echo $(green "Executing the Thumbnail Regeneration task")
  pod=$(kubectl -n $1 get pods -l=app.kubernetes.io/name=admin-gateway | tail -1 | awk '{print $1}')
  kubectl exec -n $1 --tty --stdin "$pod" -c admin-gateway -- /usr/bin/curl -vvv "http://asset/assets/reconvert-thumbnails" \
    --header "Content-Type: application/json" \
    --data-raw '{ "organizationsUuids": [ "'$2'" ]}"'
  echo
}

# If we don't have the organization_uuid but have the slug, we need to query the database for its
# value. It's important to note that we need to be connected to the VPN to be able to access the
# database.
#
# Args
# ----
#
# 1. environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# 2. slug Slug of the organization that need to have its thumbnails regenerated.
_thumbnail_slug() {
  _check_vpn
  _save_current_account "vntana-platform-2-$1"
  _get_postgres_creds $1

  echo $(green "Getting the Organization UUID from the slug")
  if [ "$1" == "production" ]; then
    uuid=$(psql -c '\pset pager off' -c '\pset format unaligned' -c "SELECT json_build_object('uuid', uuid) FROM vntana_core.organization where organization_slug = '$2';" | grep "{" | jq -r '.uuid')
  else
    uuid=$(psql -c '\pset pager off' -c '\pset format unaligned' -c "SELECT json_build_object('uuid', uuid) FROM organization where organization_slug = '$2';" | grep "{" | jq -r '.uuid')
  fi

  _thumbnail_uuid $1 $uuid

  _restablish_previous_account
}
