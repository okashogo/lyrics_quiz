const AWS = require("aws-sdk");
const db = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TABLE_NAME || "";
const PRIMARY_KEY = process.env.PRIMARY_KEY || "";
// const originDomain = "https://blilyant.life";
// const originDomain = "http://localhost:3000";

const headers = {
  "Content-Type": "application/json; charset=utf-8",
  "Access-Control-Allow-Headers": "Authorization, Content-Type",
  "Access-Control-Allow-Methods": "GET, OPTIONS, PUT, DELETE, PATCH, POST",
  // "Access-Control-Allow-Origin": originDomain,
  "Access-Control-Allow-Credentials": true,
};

export const handler = async (event: any = {}): Promise<any> => {
  const request = JSON.parse(event.body);

  const params = {
    TableName: TABLE_NAME,
    Item: {
      title: request.title,
      body: request.body,
    },
  };

  try {
    // const response = await db.get(params).promise();
    const response = await db
      .put(params, (err: any, data: any) => {
        if (err) {
          console.log("error", err);
          // return { statusCode: 500, body: JSON.stringify(err) };
        } else {
          console.log("data", data);
          // return { statusCode: 200, body: JSON.stringify(data.Item) };
        }
      })
      .promise();

    return {
      statusCode: 200,
      body: JSON.stringify(response),
      headers: headers,
    };
  } catch (dbError) {
    return { statusCode: 500, body: JSON.stringify(dbError) };
  }
};
