TF = . * infrastructure/*

docs: readme-toc tf-doc

azure:
	terraform apply -var cloud=azure
	$(MAKE) kubeconfig
	$(MAKE) cert-manager
	$(MAKE) external-dns
.PHONY: azure

cert-manager:
	@helm upgrade \
		--atomic \
		--cleanup-on-fail \
		--create-namespace \
		--install \
		--namespace cert-manager \
		--repo https://charts.jetstack.io \
		--reset-values \
		--set installCRDs=true \
		--set 'extraArgs={--dns01-recursive-nameservers-only=true,--dns01-recursive-nameservers=8.8.8.8:53\,1.1.1.1:53}' \
		--wait \
		cert-manager \
		cert-manager

	@bash ./scripts.sh cert_manager
.PHONY: cert-manager

external-dns:
	@bash ./scripts.sh external_dns
.PHONY: external-dns

format:
	terraform fmt -recursive .
.PHONY: format

kubeconfig:
	mkdir -p ~/.kube
	terraform output -json kubeconfig | jq -r > ~/.kube/config
	chmod 600 ~/.kube/config

	kubectl cluster-info
.PHONY: kubeconfig

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
