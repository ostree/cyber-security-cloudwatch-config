# Cyber Security CloudWatch Config

The aim of this repository is to automate the generation of CloudWatch
alarm config.

We are starting to build a collection of standardised CloudWatch Alarm
terraform modules in
[cyber-security-shared-terraform-modules](https://github.com/alphagov/cyber-security-shared-terraform-modules)

This repository uses `cloudwatch list-metrics` to identify resources to be
monitored, queries the tags for those resources in order to classify them
into services and environments.

The aim is to produce a set of `tfvar` files containing lists of maps
containing the config for the standard modules.

Then we can implement the modules to count across those lists.

Hopefully we can then automatically generate a pull request to terraform
the alarm config.

## Lambda / python

### Generate Metric Alarms
This has been written as a lambda but potentially it could be run locally
by the concourse pipeline.

[README.md](lambda/health_package/README.md)

### Health Monitor
This lambda subscribes to an SNS health topic and routes the alarm to
appropriate notification SNS topics.

[README.md](lambda/health_package/README.md)

## Terraform

Reconfigure terraform state to current account
```
cd terraform/deployable
terraform init -reconfigure -backend-config=../deployments/[account]/backend.tfvars
```

Apply using tfvars generated by python script
```
# change script to generate alarms into tf/deployments folder
terraform apply -var-file=../../lambda/generate_metric_alarms/output/[account]/alarms.tfvars
```

## Concourse 

There are some pipelines in the concourse folder.

### cloudwatch
Runs: 
1. Generate metric alarms (to create alarms.tfvars for each account)
2. Terraform (per_account) to deploy the cloudwatch alarms and 
    forwarders. 
3. Terraform (per_dashboard_environment) to deploy the health monitoring
    infrastructure to notify splunk and slack of health events. 

[README.md](concourse/cloudwatch/README.md) 

### concourse-heartbeat
Check that our concourse workers are healthy. 
We had an issue where our pipelines failed because there 
were no workers available. 
[README.md](concourse/heartbeat/README.md)

### slack-webhook-checker
Check that all the slack webhooks configured in SSM are 
operational. 
We had an issue where we were posting to a webhook where 
the channel name had been changed so it wasn't working. 
[README.md](concourse/slack-webhook-checker/README.md)

## Docker

There are 2 Dockerfiles: 
1. terraform-container - [README.md](docker/concourse-worker-health/README.md)
    Installs a specified version of terraform and contains scripts
    to perform an STS:AssumeRole operation to assume the role for 
    a given pipeline. 

2. http-api-container - [README.md](docker/http-api-resource/README.md)
    Replaces the standard `aequitas/http-api-resource` container 
    kernel with a more recent version to patch vulnerabilities.

