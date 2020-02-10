'use strict'

var AWS = require('aws-sdk');
var s3 = new AWS.S3();

async function writeToBucket(key, json) {

    var params = {
        Bucket: "staging-vehicle-test-results",
        Key: key + ".json",
        Body: JSON.stringify(json)
    };

    return s3.putObject(params).promise();     
}

exports.handler = async (event, context) => {  
    return await writeToBucket(context.awsRequestId, event.detail);
};
