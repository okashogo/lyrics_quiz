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

    const getAllQuizzesLambda = new Function(this, "getAllQuizzesLambda", {
      code: new AssetCode("lib/lambda"),
      handler: "getAllQuizzesLambda.handler",
      runtime: Runtime.NODEJS_14_X,
      environment: {
        TABLE_NAME: dynamoTable.tableName,
        PRIMARY_KEY: "title",
      },
    });
    dynamoTable.grantReadData(getAllQuizzesLambda);

    const storeAllQuizzesLambda = new Function(this, "storeAllQuizzesLambda", {
      code: new AssetCode("lib/lambda"),
      handler: "storeQuizzesLambda.handler",
      runtime: Runtime.NODEJS_14_X,
      environment: {
        TABLE_NAME: dynamoTable.tableName,
        PRIMARY_KEY: "title",
      },
    });
    dynamoTable.grantReadWriteData(storeAllQuizzesLambda);

    const deleteQuizzesLambda = new Function(this, "deleteQuizzesLambda", {
      code: new AssetCode("lib/lambda"),
      handler: "deleteQuizzesLambda.handler",
      runtime: Runtime.NODEJS_14_X,
      environment: {
        TABLE_NAME: dynamoTable.tableName,
        PRIMARY_KEY: "title",
      },
    });
    dynamoTable.grantReadWriteData(deleteQuizzesLambda);

    // ApiGateway
    const lyricsQuizApi = new RestApi(this, "LyricsQuizApi", {
      restApiName: "LyricsQuiz API",
    });
    const getItemIntegration = new LambdaIntegration(getAllQuizzesLambda);
    lyricsQuizApi.root.addMethod("GET", getItemIntegration);
    const storeItemIntegration = new LambdaIntegration(storeAllQuizzesLambda);
    lyricsQuizApi.root.addMethod("POST", storeItemIntegration);
    const deleteItemIntegration = new LambdaIntegration(deleteQuizzesLambda);
    lyricsQuizApi.root.addMethod("DELETE", deleteItemIntegration);

    // The code that defines your stack goes here

    // example resource
    // const queue = new sqs.Queue(this, 'CdkQueue', {
    //   visibilityTimeout: cdk.Duration.seconds(300)
    // });
  }
}

export function addCorsOptions(apiResource: IResource) {
  apiResource.addMethod(
    "OPTIONS",
    new MockIntegration({
      integrationResponses: [
        {
          statusCode: "200",
          responseParameters: {
            "method.response.header.Access-Control-Allow-Headers":
              "'Content-Type,access-control-allow-headers,access-control-expose-headers,access-control-allow-origin,access-control-allow-methods,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
            // "method.response.header.Access-Control-Allow-Origin": originDomain,
            "method.response.header.Access-Control-Allow-Credentials": "'true'",
            "method.response.header.Access-Control-Allow-Methods":
              "'OPTIONS,GET,PUT,POST,DELETE'",
          },
        },
      ],
      passthroughBehavior: PassthroughBehavior.NEVER,
      requestTemplates: {
        "application/json": '{"statusCode": 200}',
      },
    }),
    {
      methodResponses: [
        {
          statusCode: "200",
          responseParameters: {
            "method.response.header.Access-Control-Allow-Headers": true,
            "method.response.header.Access-Control-Allow-Methods": true,
            "method.response.header.Access-Control-Allow-Credentials": true,
            "method.response.header.Access-Control-Allow-Origin": true,
          },
        },
      ],
    }
  );
}

const app = new cdk.App();
new CdkStack(app, "CdkStack");
app.synth();
