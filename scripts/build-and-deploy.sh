#!/bin/bash
set -euo pipefail

readonly REGISTRY="${1:?Remote image registry domain must be set}"

readonly PROJECT_NAME=$(gradle properties -q | grep "name:" | awk '{print $2}')
readonly BUILD_VERSION=$(gradle properties -q | grep "version:" | awk '{print $2}')

main() {
  ./gradlew -project-prop registry="$REGISTRY" bootBuildImage
  # Add timestamp to avoid node caching
  local image="$REGISTRY/$PROJECT_NAME:$BUILD_VERSION-$(date +%s)"
  docker tag "$REGISTRY/$PROJECT_NAME:$BUILD_VERSION" $image
  docker push $image
  kubectl create deploy $PROJECT_NAME --image $PROJECT_NAME -o json --dry-run=client | jq ".spec.template.spec.containers[0].image=\"$image\"" | kubectl apply -f -
}

main
