import * as cdk from "@aws-cdk/core";
import { Table, AttributeType } from "@aws-cdk/aws-dynamodb";
import { AssetCode, Function, Runtime } from "@aws-cdk/aws-lambda";
import {
  Cors,
  RestApi,
  LambdaIntegration,
  IResource,
  MockIntegration,
  PassthroughBehavior,
} from "@aws-cdk/aws-apigateway";
// import * as sqs from '@aws-cdk/aws-sqs';

export class CdkStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const dynamoTable = new Table(this, "LyricsQuiz", {
      partitionKey: {
        name: "title",
        type: AttributeType.STRING,
      },
      tableName: "quizzes",
      removalPolicy: cdk.RemovalPolicy.RETAIN, // NOT recommended for production code
    });

    // The code that defines your stack goes here

    // example resource
    // const queue = new sqs.Queue(this, 'CdkQueue', {
    //   visibilityTimeout: cdk.Duration.seconds(300)
    // });
  }
}
