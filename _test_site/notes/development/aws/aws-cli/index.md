# aws-cli


## AWS CLI &amp; Metadata

### Retrieve Instance Region

The metadata service uses tokens now, so this requires an additional step.

```shell
TOKEN=$(curl --silent --show-error --fail -X PUT &#34;http://169.254.169.254/latest/api/token&#34; -H &#34;X-aws-ec2-metadata-token-ttl-seconds: 21600&#34;)
RESPONSE=$(curl --silent  --show-error --fail -H &#34;X-aws-ec2-metadata-token: $TOKEN&#34;  http://169.254.169.254/latest/meta-data/placement/region)
echo &#34;Current Region is: [$RESPONSE]&#34;
```

## List Matching Instances

Here, output is used with `--output json` and `jq`, but you can also use `--output text`.

```shell
aws ec2 describe-instances --filters &#34;Name=tag:Name,Values={{ .EC2_NAME_FILTER }}&#34; --output json \
--query &#39;Reservations[*].Instances[*].{Instance:InstanceId}&#39; | jq --compact-output &#39;.[][].Instance&#39;
```

## List Standard Users

```shell
getent passwd {1000..60000}
```

