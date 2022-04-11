#!/bin/bash

NAMESPACE=gitpod

function cert_manager() {
  echo "Configuring cert-manager"

  get_output cert_manager_secret > tmp/secret

  if [ $(jq length tmp/secret) -eq "0" ]; then
    kubectl delete secret dns --namespace cert-manager
  else
    cmd="kubectl create secret generic dns --namespace cert-manager"
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

  yq e -i ".metadata.namespace = \"${NAMESPACE}\"" tmp/issuer.yaml
  yq e -i ".spec.acme.solvers = $(terraform output -json cert_manager_issuer)" tmp/issuer.yaml

  kubectl apply -f tmp/issuer.yaml
}

function external_dns() {
  echo "Configuring External DNS"

  kubectl create namespace external-dns || true

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
		--namespace external-dns \
		--repo https://charts.bitnami.com/bitnami \
		--reset-values \
		--set logFormat=json \
		--wait"
  while IFS= read -r line; do
    cmd+=" --set ${line}"
  done <<< $(get_output external_dns_settings | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]')
  cmd+=" external-dns external-dns"

  eval ${cmd}
}

function get_output() {
  terraform output -json "${1}"
}

############
# Commands #
############

cmd="${1:-}"
mkdir -p tmp

case "${cmd}" in
  cert_manager )
    cert_manager
    ;;
  external_dns )
    external_dns
    ;;
  * )
    echo "Unknown command: ${cmd}"
    exit 1
    ;;
esac
