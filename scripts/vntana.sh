#!/usr/bin/env bash

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

# @describe Common VNTANA tasks cli

# @cmd Connect to the PostgreSQL database using `psql` or `pgcli`.
# @arg environment![development|acceptance|staging|production] VNTANA environment where the update should be applied.
psql() {
  # Check if we are connected to the VPN
  public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
  if [ "$public_ip" != "144.202.120.51" ]; then
    echo $(red "You need to be connected to the VPN to run this command")
    exit 1
  fi

  echo $(green "Saving reference to current gcloud account")
  current_account=$(gcloud config configurations list | grep True | awk '{print $1}')
  echo $current_account

  echo $(green "Connecting to the correct google cloud account")
  gcloud config configurations activate vntana-platform-2-$argc_environment | grep $argc_environment

  echo $(green "Saving reference to current cluster")
  current_cluster=$(kubectl config get-contexts | grep -E "^\*" | awk '{print $2}')
  echo $current_cluster

  echo $(green "Connecting to the") $(yellow $argc_environment) $(green "Kubernetes Cluster")
  kubectl config use-context $(kubectl config get-contexts | grep $argc_environment | awk '{print $2}') | grep $argc_environment

  echo $(green "Getting PostgreSQL credentials for the") $(yellow $argc_environment) $(green cluster)
  if [ "$argc_environment" == "production" ]; then
    secret="postgres-secret"
    export PGUSER=vntana
  else
    secret="core-postgres-secret"
    export PGUSER=core
  fi
  export PGPASSWORD=$(kubectl -n $argc_environment get secret/"$secret" -o json | jq '.data.password' -r | base64 --decode)
  export PGHOST=$(gcloud sql instances describe $(gcloud sql instances list --format=json | jq -r '.[0].name') --format=json | jq '.ipAddresses[0].ipAddress' -r)
  export PGPORT=5432
  export PGDATABASE=vntana
  env | grep PG

  if [[ -n "$(command -v pgcli)" ]]; then
    bin="pgcli"
  elif [[ -n "$(command -v psql)" ]]; then
    bin="psql"
  else
    echo -e "${BG_RED}Error: ${NC}${RED} You need to install either psql or pgcli to run this command ${NC}"
    exit 1
  fi

  "$bin"

  echo $(green "Restablishing previous cluster connection")
  if [ -z "$current_cluster" ]; then
    kubeclr
  else
    kubectl config use-context $current_cluster
  fi

  echo $(green "Restablishing previous account connection")
  if [ ! -z "$current_account" ]; then
    gcloud config configurations activate $current_account
  fi

  echo $(green Done)
}

# @cmd Watch pods in a namespace.
# @option -e --environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# @option -n --namespace Kubernetes namespace
watch() {
  _connect_to_cluster $argc_environment

  if [[ -z $argc_namespace ]]; then
    argc_namespace=$argc_environment
  fi

  trap ctrl_c INT

  ctrl_c() {
    echo
    _reconnect_to_cluster
    exit $#
  }

  while True; do
   content=$(kubectl -n $argc_namespace get pods --sort-by=.metadata.creationTimestamp)
   clear
   printf "$content"
   sleep 2
  done
}

CURRENT_CLUSTER=""
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


# @cmd    Regenerates the thumbnails for an organization.
# @option -e --environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# @option -s --slug Slug of the organization that need to have its thumbnails regenerated.
# @option -u --uuid Organization UUID.
thumbnail() {
  echo $(green "Saving reference to current cluster")
  current_cluster=$(kubectl config get-contexts | grep -E "^\*" | awk '{print $2}')
  echo $current_cluster

  echo $(green "Connecting to the") $(yellow $argc_environment) $(green "Kubernetes Cluster")
  kubectl config use-context $(kubectl config get-contexts | grep vntana-$argc_environment | awk '{print $2}')

  if [[ -n $argc_slug ]]; then
    _thumbnail_slug $argc_environment $argc_slug
  else
    _thumbnail_uuid $argc_environment $argc_uuid
  fi

  echo $(green "Connecting to the") $(yellow $argc_environment) $(green "Kubernetes Cluster")
  kubectl config use-context $(kubectl config get-contexts | grep $argc_environment | awk '{print $2}') | grep $argc_environment

  echo $(green "Restablishing previous cluster connection")
  if [ -z "$current_cluster" ]; then
    kubeclr
  else
    kubectl config use-context $current_cluster
  fi

  echo $(green Done)
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
    # Check if we are connected to the VPN
  public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
  if [ "$public_ip" != "144.202.120.51" ]; then
    echo $(red "You need to be connected to the VPN to run this command")
    exit 1
  fi

  echo $(green "Saving reference to current gcloud account")
  current_account=$(gcloud config configurations list | grep True | awk '{print $1}')
  echo $current_account

  echo $(green "Connecting to the correct google cloud account")
  gcloud config configurations activate vntana-platform-2-$1 | grep $1

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

  echo $(green "Getting the Organization UUID from the slug")
  if [ "$1" == "production" ]; then
    uuid=$(psql -c '\pset pager off' -c '\pset format unaligned' -c "SELECT json_build_object('uuid', uuid) FROM vntana_core.organization where organization_slug = '$2';" | grep { | jq -r '.uuid')
  else
    uuid=$(psql -c '\pset pager off' -c '\pset format unaligned' -c "SELECT json_build_object('uuid', uuid) FROM organization where organization_slug = '$2';" | grep { | jq -r '.uuid')
  fi

  _thumbnail_uuid $1 $uuid

  echo $(green "Restablishing previous account connection")
  if [ ! -z "$current_account" ]; then
    gcloud config configurations activate $current_account
  fi
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

# @cmd    Upgrades the version of a service
# @alias  u
# @option -e --environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# @option -p --path=/Users/gmonne/Projects/Vntana/vntana-configs/branches/master/gke-configs/vntana-platform-2 VNTANA service definition path.
# @arg    service! Name of the service to upgrade.
upgrade() {
  echo $(green "Checking if") $(yellow vntana-configs) $(green "repository is clean")
  cd ~/Projects/Vntana/vntana-configs/branches/master
  if ! git diff --exit-code --quiet origin/master ; then
    echo $(red "You need to commit all changes or download the latest changes of the" ) $(yellow vntana-configs) $(red "repository before continuing")
    exit 1
  fi

  echo $(green "Saving reference to current cluster")
  current_cluster=$(kubectl config get-contexts | grep -E "^\*" | awk '{print $2}')

  echo $(green "Connecting to the") $(yellow $argc_environment) $(green "Kubernetes Cluster")
  kubectl config use-context $(kubectl config get-contexts | grep vntana-$argc_environment | awk '{print $2}')

  echo $(green "Upgrading service") $(yellow $argc_service) $(green "on the") $(yellow $argc_environment) $(green environment)
  helm -n $argc_environment upgrade $argc_service -f "$argc_path/$argc_service/values-$argc_environment.yaml" "$argc_path/$argc_service"

  echo $(green "Restablishing previous cluster connection")
  if [ -z "$current_cluster" ]; then
    kubeclr
  else
    kubectl config use-context $current_cluster
  fi

  echo $(green Done)
}

# @cmd    Executes into a pod
# @alias  x
# @option -e --environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# @option -n --namespace Namespace where the pod is running.
# @arg    service! Service to execute into
execute() {
  echo $(green "Saving reference to current cluster")
  current_cluster=$(kubectl config get-contexts | grep -E "^\*" | awk '{print $2}')

  echo $(green "Connecting to the") $(yellow $argc_environment) $(green "Kubernetes Cluster")
  kubectl config use-context $(kubectl config get-contexts | grep $argc_environment | awk '{print $2}')

  echo $(green Executing into service) $(yellow $argc_service) $(green on the) $(yellow $argc_environment) $(green environment)
  if [[ -z "$argc_namespace" ]]; then
    pod=$(kubectl -n $argc_environment get pods -l=app.kubernetes.io/name=$argc_service | tail -1 | awk '{print $1}')
  else
    pod=$(kubectl -n $argc_namespace get pods $argc_service | tail -1 | awk '{print $1}')
  fi
  if [[ -z "$pod" ]]; then
    echo $(red "Can't find a pod for service") $(yellow $argc_service)
  else
    echo $pod
    kubectl exec -n $([[ ! -z "$argc_namespace" ]] && echo $argc_namespace || echo $argc_environment) --tty --stdin "$pod" -- /bin/bash
  fi

  echo $(green Restablishing previous cluster connection)
  if [ -z "$current_cluster" ]; then
    kubeclr
  else
    kubectl config use-context $current_cluster
  fi

  echo $(green Done)
}

# @cmd    Updates the current version of the ModelOps Request Handler
# @alias  r
# @option -e --environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# @option -p --path=/Users/gmonne/Projects/Vntana/model-ops-configs ModelOps configs project path.
# @arg    tag! Tag of the image to update.
release() {
  echo $(green "Checking if") $(yellow model-ops-configs) $(green "repository is clean")
  cd ~/Projects/Vntana/model-ops-configs
  if ! git diff --exit-code --quiet origin/master ; then
    echo $(red "You need to commit all changes or pull the latest changes of the" ) $(yellow model-ops-configs) $(red "repository before continuing")
    exit 1
  fi

  echo $(green "Saving reference to current gcloud account")
  current_account=$(gcloud config configurations list | grep True | awk '{print $1}')

  echo $(green "Connecting to the") $(yellow vntana-platform-2 ) $(green account)
  gcloud config configurations activate vntana-platform-2

  echo $(green "Getting the latest image of the") $(yellow model-ops-request-handler:$argc_tag)
  image=$(gcloud container images describe us.gcr.io/vntana-platform-2/model-ops-request-handler:$argc_tag --format=json | jq '.image_summary.fully_qualified_digest' -r)
  echo $image

  echo $(green "Updating the") $(yellow $argc_environment) $(green "ModelOps request config ConfigMap")
  tmp=$(mktemp)
  config="$argc_path/$argc_environment/k8s/configs/model-ops-request-configmap.yml"
  echo $config
  cat $config | yq '. * { "data": { "MODEL_OPS_REQUEST_HANDLER_IMAGE": "'$image'" } }' -y > $tmp
  mv -f $tmp $config
  cat $config

  echo $(green "Commit changes to the") $(yellow $argc_environment) $(green "configuration file")
  git add .
  git commit -m "feat($argc_environment): update request-handler version"

  echo $(green "Saving reference to current cluster")
  current_cluster=$(kubectl config get-contexts | grep -E "^\*" | awk '{print $2}')

  echo $(green "Connecting to the") $(yellow $argc_environment) $(green "Kubernetes Cluster")
  kubectl config use-context $(kubectl config get-contexts | grep $argc_environment | awk '{print $2}')

  echo $(green "Deploying the new") $(yellow model-ops-request-handler) $(green version)
  kubectl apply -f ${config} -n model-ops
  kubectl -n model-ops get configmap/model-ops-request-config -o yaml

  echo $(green "Restablishing previous cluster connection")
  if [ -z "$current_cluster" ]; then
    kubeclr
  else
    kubectl config use-context $current_cluster
  fi

  echo $(green "Restablishing previous account connection")
  if [ ! -z "$current_account" ]; then
    gcloud config configurations activate $current_account
  fi
  echo $(green Done)
}

# @cmd    Lints a pipeline
# @alias  l
# @option --hostname=ci.vntana.com jenkins server hostname
# @arg file=Jenkinsfile jenkins pipeline path to lint
jenkins-lint() {
  echo $(green "Getting credentials for") $(yellow $argc_hostname)
  local auth=$(cat "$HOME/Projects/Personal/secrets/jenkins/$argc_hostname")
  echo $(green "Create JENKINS_CRUMB")
  local crumb=$(curl "$argc_hostname/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")
  echo $(green "Validating pipeline")
  curl -sL -X POST -H "$crumb" -F "jenkinsfile=<$argc_file" "$argc_hostname/pipeline-model-converter/validate" --anyauth --user "$auth" -vvv
}

# Run argc
eval "$(argc $0 "$@")"
