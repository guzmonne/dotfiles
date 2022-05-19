#!/usr/bin/env bash
source $(dirname "$0")/vntantan_utils.sh

# @describe Common VNTANA tasks cli

# @cmd Connect to the PostgreSQL database using `psql` or `pgcli`.
# @arg environment![development|acceptance|staging|production] VNTANA environment where the update should be applied.
psql() {
  _check_vpn
  _save_current_account "vntana-platform-2-$argc_environment"
  _connect_to_cluster $argc_environment
  _get_postgres_creds $argc_environment
  
  if [[ -n "$(command -v pgcli)" ]]; then
    bin="pgcli"
  elif [[ -n "$(command -v psql)" ]]; then
    bin="psql"
  else
    echo -e "${BG_RED}Error: ${NC}${RED} You need to install either psql or pgcli to run this command ${NC}"
    exit 1
  fi

  "$bin"

  _reconnect_to_cluster
  _restablish_previous_account
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

# @cmd    Regenerates the thumbnails for an organization.
# @option -e --environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# @option -s --slug Slug of the organization that need to have its thumbnails regenerated.
# @option -u --uuid Organization UUID.
thumbnail() {
  _connect_to_cluster $argc_environment

  if [[ -n $argc_slug ]]; then
    _thumbnail_slug $argc_environment $argc_slug
  else
    _thumbnail_uuid $argc_environment $argc_uuid
  fi

  _reconnect_to_cluster

  echo $(green Done)
}

# @cmd    Upgrades the version of services
# @alias  u
# @option -e --environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# @option -p --path=/Users/gmonne/Projects/Vntana/vntana-configs/branches/master VNTANA configs definition path.
# @arg    services! Name of the services to upgrade separted by comma.
upgrade() {
  echo $(green "Checking if") $(yellow vntana-configs) $(green "repository is clean")
  if [[ -n $argc_path ]]; then
    cd $argc_path
  else
    cd ~/Projects/Vntana/vntana-configs/branches/master
  fi
  if ! git diff --exit-code --quiet origin/master ; then
    echo $(red "You need to commit all changes or download the latest changes of the" ) $(yellow vntana-configs) $(red "repository before continuing")
    exit 1
  fi

  _connect_to_cluster $argc_environment

  IFS=',' read -ra ADDR <<< $argc_services
  for service in "${ADDR[@]}"; do
    echo $(green "Upgrading service") $(yellow $service) $(green "on the") $(yellow $argc_environment) $(green environment)
    helm -n $argc_environment upgrade $service -f "$argc_path/gke-configs/vntana-platform-2/$service/values-$argc_environment.yaml" "$argc_path/$service"
  done

  _reconnect_to_cluster

  echo $(green Done)
}

# @cmd    Executes into a pod
# @alias  x
# @option -e --environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# @option -n --namespace Namespace where the pod is running.
# @arg    service! Service to execute into
execute() {
  _connect_to_cluster $argc_environment

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

  _reconnect_to_cluster

  echo $(green Done)
}

# @cmd    Updates the current version of the ModelOps Request Handler
# @alias  r
# @option -e --environment[development|acceptance|staging|production] VNTANA environment where the update should be applied.
# @option -p --path=/Users/gmonne/Projects/Vntana/model-ops-configs ModelOps configs project path.
# @arg    tag! Tag of the image to update.
release() {
  echo $(green "Checking if") $(yellow model-ops-configs) $(green "repository is clean")
  if [[ -n $argc_path ]]; then
    cd $argc_path
  else
    cd cd ~/Projects/Vntana/model-ops-configs
  fi
  if ! git diff --exit-code --quiet origin/master ; then
    echo $(red "You need to commit all changes or pull the latest changes of the" ) $(yellow model-ops-configs) $(red "repository before continuing")
    exit 1
  fi

  _save_current_account "vntana-platform-2"

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

  _connect_to_cluster $argc_environment

  echo $(green "Deploying the new") $(yellow model-ops-request-handler) $(green version)
  kubectl apply -f ${config} -n model-ops
  kubectl -n model-ops get configmap/model-ops-request-config -o yaml

  _reconnect_to_cluster

  _restablish_previous_account

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
  local crumb=`curl "$argc_hostname/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"`
  echo $(green "Validating pipeline")
  curl -sL -X POST -H "$crumb" -F "jenkinsfile=<$argc_file" "$argc_hostname/pipeline-model-converter/validate" --anyauth --user "$auth" -vvv
}

# Run argc
eval "$(argc $0 "$@")"
