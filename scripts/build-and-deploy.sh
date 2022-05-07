#!/bin/bash
set -euo pipefail

IS_KIND_CLUSTER="false" && [[ "$(kubectl config view -o json | jq -r '.["current-context"]')" =~ "kind-"* ]] && IS_KIND_CLUSTER="true"
  
if [[ "$IS_KIND_CLUSTER" == "false" ]]; then
  readonly REGISTRY="${1:?Remote image registry domain must be set}"  
else
  readonly REGISTRY="local"
fi
  
readonly PROJECT_NAME=$(gradle properties -q | grep "name:" | awk '{print $2}')
readonly PROJECT_VERSION=$(gradle properties -q | grep "version:" | awk '{print $2}')
readonly IMAGE="$REGISTRY/$PROJECT_NAME:$PROJECT_VERSION-$(date +%Y%m%d%H%M%S)"

build() {
  ./gradlew --project-prop registry="$REGISTRY" bootBuildImage  
}

push() {
   # Add timestamp to avoid node caching
  docker tag "$REGISTRY/$PROJECT_NAME:$PROJECT_VERSION" $IMAGE
      
  if [[ "$IS_KIND_CLUSTER" == "true" ]]; then
    kind load docker-image "$IMAGE"
  else
    docker push $IMAGE
  fi
}

deploy() {
  kubectl create deploy $PROJECT_NAME --image $PROJECT_NAME -o json --dry-run=client | jq ".spec.template.spec.containers[0].image=\"$IMAGE\"" | kubectl apply -f -
}

main() {
  build
  push
  deploy
}

main
