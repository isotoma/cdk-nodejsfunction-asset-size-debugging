import * as cdk from '@aws-cdk/core';
import * as lambda from '@aws-cdk/aws-lambda';
import { NodejsFunction } from '@aws-cdk/aws-lambda-nodejs';

const app = new cdk.App();
const stack = new cdk.Stack(app, 'mystack');
new NodejsFunction(stack, 'fn', {
    entry: './src/fn.ts',
    runtime: lambda.Runtime.NODEJS_12_X,
    handler: 'handler',
});
