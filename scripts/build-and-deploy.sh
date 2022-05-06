#!/bin/bash
set -euo pipefail

readonly PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
readonly WAVEFRONT_API_TOKEN="${1:?Wavefront API token must be set}"
readonly DASHBOARD_LOCATION="${PROJECT_ROOT}/dashboards/wavefront-spring-cloud-gateway-for-kubernetes.json"

export_dashboard() {
  curl 'https://vmware.wavefront.com/api/v2/dashboard/Spring-Cloud-Gateway-for-Kubernetes' \
    --header "Authorization: Bearer ${WAVEFRONT_API_TOKEN}" |
    jq .response -M >"${DASHBOARD_LOCATION}"
}

main() {
  ./gradlew clean bootBuildImage
  kubectl create
}

main
