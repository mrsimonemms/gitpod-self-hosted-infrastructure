TF = . * infrastructure/*

docs: readme-toc tf-doc

azure:
	terraform apply -var cloud=azure
	$(MAKE) kubeconfig
	$(MAKE) cert-manager
	$(MAKE) external-dns
.PHONY: azure

azure-k3s:
	terraform apply -var cloud=azure -var azure_k3s=true
	$(MAKE) k3s
	$(MAKE) cert-manager
.PHONY: azure-k3s

cert-manager:
	@bash ./scripts.sh cert_manager
.PHONY: cert-manager

external-dns:
	@bash ./scripts.sh external_dns
.PHONY: external-dns

format:
	terraform fmt -recursive .
.PHONY: format

hetzner:
	terraform apply -var cloud=hetzner
	$(MAKE) k3s
	$(MAKE) cert-manager
.PHONY: hetzner

k3s:
	@bash ./scripts.sh k3s
.PHONY: k3s

kubeconfig:
	mkdir -p ~/.kube
	terraform output -json kubeconfig | jq -r > ~/.kube/config
	chmod 600 ~/.kube/config

	kubectl cluster-info
.PHONY: kubeconfig

install:
	@bash ./scripts.sh install
.PHONY: install

new-provider:
	@bash ./scripts.sh new_provider
.PHONY: new-provider

readme-toc:
	# Required Markdown TOC
	# @link https://github.com/jonschlinkert/markdown-toc
	for dir in ${TF}; do \
		markdown-toc $${dir}/README.md -i || true; \
	done
.PHONY: readme-toc

tf-doc:
	# Requires Terraform Docs
	# @link https://github.com/terraform-docs/terraform-docs
	for dir in ${TF}; do \
  		terraform-docs \
  			-c .terraform-docs.yml \
  			$${dir} || true; \
  	done
.PHONY: tf-doc
