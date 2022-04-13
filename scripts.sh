#!/bin/bash

set -e

NAMESPACE=gitpod
CERT_MANAGER_NAMESPACE=cert-manager
EXTERNAL_DNS_NAMESPACE=external-dns

function cert_manager() {
  echo "Configuring cert-manager"

  kubectl create namespace "${CERT_MANAGER_NAMESPACE}" || true

  local AIRGAPPED_TAG="v1.8.0"

  if [ $(enable_airgapped) == "true" ]; then
    image_pull_secret "${CERT_MANAGER_NAMESPACE}"

    mirror_image \
      "quay.io/jetstack/cert-manager-controller:${AIRGAPPED_TAG}" \
      "$(get_registry | jq -r '.server')/jetstack/cert-manager-controller:${AIRGAPPED_TAG}"

    mirror_image \
      "quay.io/jetstack/cert-manager-webhook:${AIRGAPPED_TAG}" \
      "$(get_registry | jq -r '.server')/jetstack/cert-manager-webhook:${AIRGAPPED_TAG}"

    mirror_image \
      "quay.io/jetstack/cert-manager-cainjector:${AIRGAPPED_TAG}" \
      "$(get_registry | jq -r '.server')/jetstack/cert-manager-cainjector:${AIRGAPPED_TAG}"

    mirror_image \
      "quay.io/jetstack/cert-manager-ctl:${AIRGAPPED_TAG}" \
      "$(get_registry | jq -r '.server')/jetstack/cert-manager-ctl:${AIRGAPPED_TAG}"
  fi

  cmd="helm upgrade \
		--atomic \
		--cleanup-on-fail \
		--create-namespace \
		--install \
		--namespace cert-manager \
		--repo https://charts.jetstack.io \
		--reset-values \
		--set installCRDs=true \
		--set 'extraArgs={--dns01-recursive-nameservers-only=true,--dns01-recursive-nameservers=8.8.8.8:53\,1.1.1.1:53}' \
    --version ${AIRGAPPED_TAG} \
		--wait"
  if [ $(enable_airgapped) == "true" ]; then
    cmd+=" --set=image.registry=$(get_registry | jq -r '.server')"
    cmd+=" --set=image.repository=jetstack/cert-manager-controller"
    cmd+=" --set=cainjector.image.registry=$(get_registry | jq -r '.server')"
    cmd+=" --set=cainjector.image.repository=jetstack/cert-manager-cainjector"
    cmd+=" --set=startupapicheck.image.registry=$(get_registry | jq -r '.server')"
    cmd+=" --set=startupapicheck.image.repository=jetstack/cert-manager-ctl"
    cmd+=" --set=webhook.image.registry=$(get_registry | jq -r '.server')"
    cmd+=" --set=webhook.image.repository=jetstack/cert-manager-webhook"
    cmd+=" --set=\"global.imagePullSecrets[0].name=registry\""
  fi
  cmd+=" cert-manager cert-manager"

  eval $cmd

  eval "${cmd}"

  get_output cert_manager_secret > tmp/secret

  if [ $(jq length tmp/secret) -eq "0" ]; then
    kubectl delete secret dns --namespace "${CERT_MANAGER_NAMESPACE}" || true
  else
    cmd="kubectl create secret generic dns --namespace ${CERT_MANAGER_NAMESPACE}"
    while IFS= read -r line; do
      cmd+=" --from-literal ${line}"
    done <<< $(cat tmp/secret | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]')
    cmd+=" --dry-run=client -o yaml | kubectl replace -f -"

    eval ${cmd}
  fi

  cat << EOF > tmp/issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: gitpod-issuer
spec:
  acme:
    privateKeySecretRef:
      name: issuer-account-key
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers: []
EOF

  yq e -i ".spec.acme.solvers = $(terraform output -json cert_manager_issuer)" tmp/issuer.yaml

  kubectl apply -f tmp/issuer.yaml
}

function enable_airgapped() {
  if [ ! -f tmp/airgapped.json ]; then
    terraform output enable_airgapped > tmp/airgapped.json
  fi

  cat tmp/airgapped.json
}

function external_dns() {
  echo "Configuring External DNS"

  kubectl create namespace "${EXTERNAL_DNS_NAMESPACE}" || true

  local AIRGAPPED_TAG="0.10.2-debian-10-r27"

  if [ $(enable_airgapped) == "true" ]; then
    image_pull_secret "${EXTERNAL_DNS_NAMESPACE}"

    mirror_image \
      "docker.io/bitnami/external-dns:${AIRGAPPED_TAG}" \
      "$(get_registry | jq -r '.server')/bitnami/external-dns:${AIRGAPPED_TAG}"
  fi

  # Install secrets
  get_output external_dns_secrets > tmp/secret

  if [ $(jq length tmp/secret) -gt "0" ]; then
    while IFS= read -r line; do
      cat tmp/secret | jq -r --arg KEY "${line}" '.[$KEY]|to_entries|map("\(.key)=\(.value|tostring)")|.[]' > tmp/secret-values

      kubectl create secret generic "${line}" \
        -n external-dns \
        --from-env-file tmp/secret-values \
        --dry-run=client \
        -o yaml | kubectl apply -f -
    done <<< $(cat tmp/secret | jq -r 'keys[]')
  fi

  cmd="helm upgrade \
    --atomic \
		--cleanup-on-fail \
		--create-namespace \
		--install \
		--namespace ${EXTERNAL_DNS_NAMESPACE} \
		--repo https://charts.bitnami.com/bitnami \
		--reset-values \
		--set logFormat=json \
		--wait"
  while IFS= read -r line; do
    cmd+=" --set ${line}"
  done <<< $(get_output external_dns_settings | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]')

  if [ $(enable_airgapped) == "true" ]; then
    cmd+=" --set=image.registry=$(get_registry | jq -r '.server')"
    cmd+=" --set=image.tag=${AIRGAPPED_TAG}"
    cmd+=" --set=image.pullSecrets={registry}"
  fi
  cmd+=" external-dns external-dns"

  eval ${cmd}
}

function get_output() {
  terraform output -json "${1}"
}

function get_registry() {
  if [ ! -f tmp/registry.json ]; then
    terraform output -json registry > tmp/registry.json
  fi

  cat tmp/registry.json
}

function image_pull_secret() {
  echo "Installing image pull secret for namespace ${1}"

  kubectl create secret docker-registry registry -n "${1}" \
    --docker-server "$(get_registry | jq -r '.server')" \
    --docker-password "$(get_registry | jq -r '.password')" \
    --docker-username "$(get_registry | jq -r '.username')" \
    --dry-run=client \
    -o yaml | kubectl apply -f -
}

function install() {
  cmd="kubectl kots install gitpod \\"
  if [ $(enable_airgapped) == "true" ]; then
    server="$(get_registry | jq -r '.server')"
    password="$(get_registry | jq -r '.password')"
    username="$(get_registry | jq -r '.username')"

    cmd+=$(printf "\n  --airgap \\")
    cmd+=$(printf "\n  --kotsadm-namespace "gitpod" \\")
    cmd+=$(printf "\n  --kotsadm-registry "${server}" \\")
    cmd+=$(printf "\n  --repo ${server} \\")
    cmd+=$(printf "\n  --registry-username ${username} \\")
    cmd+=$(printf "\n  --registry-password ${password}")

    curl -s https://api.github.com/repos/replicatedhq/kots/releases/latest \
      | jq '.assets[] | select(.name == "kotsadm.tar.gz")' \
      | jq -r '.browser_download_url' \
      | wget -i - -O tmp/kotsadm.tar.gz

    kubectl kots admin-console push-images \
      ./tmp/kotsadm.tar.gz \
      "${server}/gitpod" \
      --registry-username "${username}" \
      --registry-password "${password}"
  fi

  echo "==="
  echo "Run this command to install Gitpod via KOTS"
  echo "==="
  echo "${cmd}"
}

function mirror_image() {
  docker login "$(get_registry | jq -r '.server')" -u "$(get_registry | jq -r '.username')" -p "$(get_registry | jq -r '.password')"
  docker pull "${1}"
  docker tag "${1}" "${2}"
  docker push "${2}"
}

############
# Commands #
############

cmd="${1:-}"
rm -Rf tmp
mkdir -p tmp

case "${cmd}" in
  cert_manager )
    cert_manager
    ;;
  external_dns )
    external_dns
    ;;
  install )
    install
    ;;
  * )
    echo "Unknown command: ${cmd}"
    exit 1
    ;;
esac

rm -Rf tmp
