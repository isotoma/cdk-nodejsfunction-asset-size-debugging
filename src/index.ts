import * as cdk from '@aws-cdk/core';
import * as lambda from '@aws-cdk/aws-lambda';

const app = new cdk.App();
const stage = new cdk.Stage(app, 'mystage');
const stack = new cdk.Stack(stage, 'mystack');
new lambda.Function(stack, 'fn', {
    code: lambda.Code.fromAsset('./src/'),
    runtime: lambda.Runtime.NODEJS_12_X,
    handler: 'handler',
});
