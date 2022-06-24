FROM debian:buster-slim

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-helm"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-helm"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Kubectl

# renovate: datasource=github-tags depName=kubernetes/kubernetes extractVersion=^v(?<version>.*)$
ENV KUBE_VERSION=1.24.2

RUN apt-get update -y && \
  apt-get install -y wget && \
  wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  kubectl version --client

# Helm

# renovate: datasource=github-tags depName=helm/helm extractVersion=^v(?<version>.*)$
ENV HELM_VERSION=3.9.0

RUN apt-get update -y && \
  apt-get install -y wget && \
  wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
  chmod +x /usr/local/bin/helm && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  helm version
