FROM gitpod/workspace-node-lts
COPY --from=alpine/helm /usr/bin/helm /usr/local/bin/helm
COPY --from=bitnami/kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/kubectl
COPY --from=quay.io/terraform-docs/terraform-docs /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs
COPY --from=mikefarah/yq /usr/bin/yq /usr/local/bin/yq
# tf-env
RUN git clone https://github.com/tfutils/tfenv.git /home/gitpod/.tfenv \
  && sudo ln -s /home/gitpod/.tfenv/bin/* /usr/local/bin \
  && npm i -g markdown-toc \
  && tfenv install \
  && tfenv use latest \
  && echo 'source <(kubectl completion bash)' >> /home/gitpod/.bashrc \
  && echo 'source <(helm completion bash)' >> /home/gitpod/.bashrc
# KOTS
RUN curl https://kots.io/install | bash \
  && echo 'source <(kubectl kots completion bash)' >> /home/gitpod/.bashrc
# Azure
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
