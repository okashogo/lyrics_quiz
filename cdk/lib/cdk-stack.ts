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

    const dynamoTable = new Table(this, "OyojohoQuiz", {
      partitionKey: {
        name: "title",
        type: AttributeType.STRING,
      },
      tableName: "oyojoho_quizzes",
      removalPolicy: cdk.RemovalPolicy.RETAIN, // NOT recommended for production code
    });

    const getAllOyojohoQuizzesLambda = new Function(
      this,
      "getAllOyojohoQuizzesLambda",
      {
        code: new AssetCode("lib/lambda"),
        handler: "getAllOyojohoQuizzesLambda.handler",
        runtime: Runtime.NODEJS_14_X,
        environment: {
          TABLE_NAME: dynamoTable.tableName,
          PRIMARY_KEY: "title",
        },
      }
    );
    dynamoTable.grantReadData(getAllOyojohoQuizzesLambda);

    const storeAllOyojohoQuizzesLambda = new Function(
      this,
      "storeAllOyojohoQuizzesLambda",
      {
        code: new AssetCode("lib/lambda"),
        handler: "storeOyojohoQuizzesLambda.handler",
        runtime: Runtime.NODEJS_14_X,
        environment: {
          TABLE_NAME: dynamoTable.tableName,
          PRIMARY_KEY: "title",
        },
      }
    );
    dynamoTable.grantReadWriteData(storeAllOyojohoQuizzesLambda);

    const deleteOyojohoQuizzesLambda = new Function(
      this,
      "deleteOyojohoQuizzesLambda",
      {
        code: new AssetCode("lib/lambda"),
        handler: "deleteOyojohoQuizzesLambda.handler",
        runtime: Runtime.NODEJS_14_X,
        environment: {
          TABLE_NAME: dynamoTable.tableName,
          PRIMARY_KEY: "title",
        },
      }
    );
    dynamoTable.grantReadWriteData(deleteOyojohoQuizzesLambda);

    // ApiGateway
    const oyojohoQuizApi = new RestApi(this, "OyojohoQuizApi", {
      restApiName: "OyojohoQuiz API",
    });
    const getItemIntegration = new LambdaIntegration(
      getAllOyojohoQuizzesLambda
    );
    oyojohoQuizApi.root.addMethod("GET", getItemIntegration);
    const storeItemIntegration = new LambdaIntegration(
      storeAllOyojohoQuizzesLambda
    );
    oyojohoQuizApi.root.addMethod("POST", storeItemIntegration);
    const deleteItemIntegration = new LambdaIntegration(
      deleteOyojohoQuizzesLambda
    );
    oyojohoQuizApi.root.addMethod("DELETE", deleteItemIntegration);

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
