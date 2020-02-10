'use strict'

const AWS = require('aws-sdk');

const region = 'eu-west-2';
const eventBusName = 'EDE-vehicle-events';
const source = 'ede-services.vehicletests';

function sendCompletedTest(testResults) {

    const eventBridge = new AWS.EventBridge({ region: region }); 

    return eventBridge.putEvents({
        Entries: [
        {
            EventBusName: eventBusName,
            Source: source,
            DetailType: 'completed-test',               // This could be detail-type
            Detail: `{ "VehicleVIN": "ABC123" }`,
        }]
    }).promise();
}

exports.handler = function(event, context, callback) {
  
    sendCompletedTest(null)
        .then((result) => {

            var response = {
                statusCode: 200,
                headers: {
                  'Content-Type': 'text/html; charset=utf-8'
                },
                body: '<p>Hello world!</p>'
            }

            callback(null, response)

        })  
        .catch((err) => {
            
            var response = {
                statusCode: 500,
                headers: {
                  'Content-Type': 'text/html; charset=utf-8'
                },
                body: err
            }

            callback(null, response)
        })  
}