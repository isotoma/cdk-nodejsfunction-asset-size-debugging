# cdk-nodejsfunction-asset-size-debugging

https://github.com/aws/aws-cdk/issues/15346

Believe this to demonstrate some strange behaviour with the CDK where the following mechanisms intersect:
- `@aws-cdk/aws-lambda-nodejs.NodejsFunction`
- `@aws-cdk/core.Stage`
- the `-e` (exclusive) flag to the `synth` or `deploy` commands

Branches:
- [`main`](https://github.com/isotoma/cdk-nodejsfunction-asset-size-debugging/tree/main),
  broken behaviour. Combines the above three mechanisms, asset becomes
  a zip of the entire project root, rather than an `../asset.[hash]` path
- [`no-cdk-stage`](https://github.com/isotoma/cdk-nodejsfunction-asset-size-debugging/pull/1),
  expected behivour. Remove use of a `Stage`, attach the stack
  directly to the `App`. Asset path is as expected.
- [`non-nodejs-lambda-fn`](https://github.com/isotoma/cdk-nodejsfunction-asset-size-debugging/pull/2),
  expected behaviour. Remove `NodejsFunction` and use a regular `Function` instead. Asset path is as expected.
- [`do-not-synth-exclusive`](https://github.com/isotoma/cdk-nodejsfunction-asset-size-debugging/pull/3),
  expected behaviour. Remove the `-e` flag from the `synth`
  command. Asset path is as expected.
- (possibly unrelated):
  [`spurious-yarn-lock`](https://github.com/isotoma/cdk-nodejsfunction-asset-size-debugging/pull/4),
  broken behaviour. Add a `yarn.lock` in a parent on the project
  root. Asset path is now a zip of the _parent_ of the project root. I
  think this is because it is looking for a `yarn.lock` first, and
  this is just a knock-on effect of the issue.

Method (See the `check.sh` script):
- Runs the `synth` command, then looks in the assets manifest
- Checks if that references the absolute path to the directory
  root. If so, asserts that something strange and wrong has happened,
  as would expect the asset to be `../asset[hash]`.
