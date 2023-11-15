---
title: aws-cli
---

## AWS CLI & Metadata

### Retrieve Instance Region

Looks like the metadata service uses tokens now, so this requires an additional step.

```shell
TOKEN=`curl --silent --show-error --fail -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
RESPONSE=`curl --silent  --show-error --fail -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/placement/region`
echo "Current Region is: [$RESPONSE]"
```

## List Matching Instances

You can use output with `--output text` but for this example I used json and `jq`.

```shell
aws ec2 describe-instances --filters "Name=tag:Name,Values={{ .EC2_NAME_FILTER }}" --output json \
--query 'Reservations[*].Instances[*].{Instance:InstanceId}' | jq --compact-output '.[][].Instance'
```

## List Standard Users

```shell
getent passwd {1000..60000}
```
