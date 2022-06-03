FROM node:16.15.0-buster-slim

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-helm"
LABEL org.opencontainers.image.description="Docker image for running Helm commands in an Azure Pipelines container job"
LABEL org.opencontainers.image.url="https://github.com/swissgrc/docker-azure-pipelines-helm"
LABEL org.opencontainers.image.source="https://github.com/swissgrc/docker-azure-pipelines-helm"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-helm"

# Required for Azure Pipelines Container Jobs
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/local/bin/node"

# Kubectl

ENV KUBE_VERSION=1.24.1

RUN apt update -y && \
  apt install -y wget && \
  wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  apt clean all && \
  # Smoke test
  kubectl version --client

# Helm

ENV HELM_VERSION=3.9.0

RUN apt update -y && \
  apt install -y wget && \
  wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
  chmod +x /usr/local/bin/helm && \
  apt clean all && \
  # Smoke test
  helm version

CMD [ "node" ]
