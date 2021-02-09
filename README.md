# Docker image for running Helm commands in Azure Pipelines container jobs

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-helm/blob/main/LICENSE) [![Build](https://img.shields.io/docker/cloud/build/swissgrc/azure-pipelines-helm.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-helm/builds) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-helm.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-helm) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-helm.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-helm)

Docker image to run Helm and kubectl commands in [Azure Pipelines container jobs].

## Usage

This container can be used to run Helm and kubectl commands in [Azure Pipelines container jobs].

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

| Tag      | Description                                                                             | Size                                                                                                                          |
|----------|-----------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)                                              | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch)                                         | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/unstable?style=flat-square) |
| 3.5.1    | [Helm 3.5.1](https://github.com/helm/helm/releases/tag/v3.5.1)                          | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/3.5.1?style=flat-square)    |

### Configuration

These environment variables are supported:

| Environment variable | Default value | Description                |
|----------------------|---------------|----------------------------|
| KUBE_VERSION         | `1.20.2`      | Version of kubectl to use. |
| HELM_VERSION         | `3.5.1`       | Version of Helm to use.    |

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
