---
title: aws-cli
---

## AWS CLI & Metadata

### Retrieve Instance Region

The metadata service uses tokens now, so this requires an additional step.

```shell
TOKEN=$(curl --silent --show-error --fail -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
RESPONSE=$(curl --silent  --show-error --fail -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/placement/region)
echo "Current Region is: [$RESPONSE]"
```

## List Matching Instances

Here, output is used with `--output json` and `jq`, but you can also use `--output text`.

```shell
aws ec2 describe-instances --filters "Name=tag:Name,Values={{ .EC2_NAME_FILTER }}" --output json \
--query 'Reservations[*].Instances[*].{Instance:InstanceId}' | jq --compact-output '.[][].Instance'
```

## List Standard Users

```shell
getent passwd {1000..60000}
```
