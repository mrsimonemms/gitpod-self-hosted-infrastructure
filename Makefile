TF = . * infrastructure/*

docs: readme-toc tf-doc

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
