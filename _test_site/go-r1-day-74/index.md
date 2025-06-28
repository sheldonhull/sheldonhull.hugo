# Go R1 Day 74


## progress

- Worked with DynamoDB schema (NoSQL Document database).
- Invoked local lambda function using Docker and also remove invocation with `serverless invoke`.
This took a bit of work to figure out as the parameters weren&#39;t quite clear.
Upon using `--path` for the json template I got from AWS Lambda console, I was able to to get to invoke, and stream the logs with `--log`.
- More mage magic with promptui and other features, so I can now test a full tear down, build, publish, and invoke a test selection by running: `mage sls:destroy build sls:deploy sls:test remote`.

