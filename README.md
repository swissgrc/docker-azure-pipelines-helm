# Docker image for running Helm commands in Azure Pipelines container jobs

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-helm/blob/main/LICENSE) [![Build](https://img.shields.io/github/workflow/status/swissgrc/docker-azure-pipelines-terraform/Build/develop?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/actions/workflows/publish.yml) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-helm.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-helm) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-helm.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-helm)
<!-- markdownlint-restore -->

Docker image to run Helm and kubectl commands in [Azure Pipelines container jobs].

## Usage

This container can be used to run Helm and kubectl commands in [Azure Pipelines container jobs].

The following software is additionally available in the image:

| Software   | Included since |
|------------|----------------|
| Azure Cli  | 3.9.1          |
| .NET       | 3.9.1          |
| Docker CLI | 3.9.1          |

### Azure Pipelines Container Job

To use the image in an Azure Pipelines Container Job add the following task use it with the `container` property.

The following example shows the container used for a deployment step

```yaml
- stage: deploy
  jobs:
  - deployment: DeployWeb
    container: swissgrc/azure-pipelines-helm:latest
    environment: 'smarthotel-dev'
    strategy:
      runOnce:
        deploy:
          steps:
            - task: HelmDeploy@0
              displayName: Helm upgrade
              inputs:
                azureSubscriptionEndpoint: $(azureSubscriptionEndpoint)
                azureResourceGroup: $(azureResourceGroup)
                kubernetesCluster: $(kubernetesCluster)
                command: upgrade
                chartType: filepath
                chartPath: $(Build.ArtifactStagingDirectory)/sampleapp-v0.2.0.tgz
                releaseName: azuredevopsdemo
                install: true
                waitForExecution: false
```

### Tags

<!-- markdownlint-disable MD013 -->
| Tag      | Description                                                      | Base Image                                 | Helm   | Kubectl | Size                                                                                                                          |
|----------|------------------------------------------------------------------|--------------------------------------------|--------|---------|-------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)                       | swissgrc/azure-pipelines-azurecli:2.43.0   | 3.10.3 | 1.26.0  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch)                  | swissgrc/azure-pipelines-azurecli:2.43.0   | 3.10.3 | 1.26.0  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/unstable?style=flat-square) |
| 3.5.1    | [Helm 3.5.1](https://github.com/helm/helm/releases/tag/v3.5.1)   | node:15.8.0-alpine3.11                     | 3.5.1  | 1.20.2  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.5.1?style=flat-square)    |
| 3.9.0    | [Helm 3.9.0](https://github.com/helm/helm/releases/tag/v3.9.0)   | debian:11.3-slim                           | 3.9.0  | 1.24.2  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.9.0?style=flat-square)    |
| 3.9.1    | [Helm 3.9.1](https://github.com/helm/helm/releases/tag/v3.9.1)   | swissgrc/azure-pipelines-azurecli:2.38.0   | 3.9.1  | 1.24.3  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.9.1?style=flat-square)    |
| 3.9.2    | [Helm 3.9.2](https://github.com/helm/helm/releases/tag/v3.9.2)   | swissgrc/azure-pipelines-azurecli:2.38.0   | 3.9.2  | 1.24.3  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.9.2?style=flat-square)    |
| 3.9.2.1  | [Helm 3.9.2](https://github.com/helm/helm/releases/tag/v3.9.2)   | swissgrc/azure-pipelines-azurecli:2.39.0.1 | 3.9.2  | 1.24.3  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.9.2.1?style=flat-square)  |
| 3.9.3    | [Helm 3.9.3](https://github.com/helm/helm/releases/tag/v3.9.3)   | swissgrc/azure-pipelines-azurecli:2.39.0.1 | 3.9.3  | 1.24.3  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.9.3?style=flat-square)    |
| 3.9.4    | [Helm 3.9.4](https://github.com/helm/helm/releases/tag/v3.9.4)   | swissgrc/azure-pipelines-azurecli:2.39.0.1 | 3.9.4  | 1.25.0  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.9.4?style=flat-square)    |
| 3.10.0   | [Helm 3.10.0](https://github.com/helm/helm/releases/tag/v3.10.0) | swissgrc/azure-pipelines-azurecli:2.40.0   | 3.10.0 | 1.25.2  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.10.0?style=flat-square)   |
| 3.10.1   | [Helm 3.10.1](https://github.com/helm/helm/releases/tag/v3.10.1) | swissgrc/azure-pipelines-azurecli:2.40.0   | 3.10.1 | 1.25.2  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.10.1?style=flat-square)   |
| 3.10.2   | [Helm 3.10.2](https://github.com/helm/helm/releases/tag/v3.10.2) | swissgrc/azure-pipelines-azurecli:2.42.0   | 3.10.2 | 1.25.4  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.10.2?style=flat-square)   |
| 3.10.2   | [Helm 3.10.3](https://github.com/helm/helm/releases/tag/v3.10.3) | swissgrc/azure-pipelines-azurecli:2.43.0   | 3.10.3 | 1.26.0  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.10.3?style=flat-square)   |
<!-- markdownlint-restore -->

### Configuration

These environment variables are supported:

| Environment variable   | Default value        | Description                                                      |
|------------------------|----------------------|------------------------------------------------------------------|
| KUBE_VERSION           | `1.26.0`             | Version of kubectl installed in the image.                       |
| HELM_VERSION           | `3.10.3`             | Version of Helm installed in the image.                          |

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
