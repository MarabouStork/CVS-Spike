'use strict'

var AWS = require('aws-sdk');
var s3 = new AWS.S3();

exports.handler = (event, context, callback) => {  

    console.log('LogScheduledEvent');
    console.log('Received event:', JSON.stringify(event, null, 2));

    // var bucketName = process.env.bucketName;
    // var keyName = getKeyName(folder, filename);
    // var content = 'This is a sample text file';

    // var params = { Bucket: bucketName, Key: keyName, Body: content };

    // s3.putObject(params, function (err, data) {
    //     if (err)
    //         console.log(err)
    //     else
    //         console.log("Successfully saved object to " + bucketName + "/" + keyName);
    // });

    callback(null, 'Finished');        

};

// function getKeyName(folder, filename) {
//     return folder + '/' + filename;
// }

