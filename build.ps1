# aws s3 mb s3://cvs-spike-backend --region eu-west-2 --endpoint-url https://s3.eu-west-2.amazonaws.com

zip .\cvs-spike-backend\test-results.zip .\cvs-spike-backend\test-results\main.js
aws s3 cp .\cvs-spike-backend\test-results.zip s3://cvs-spike-backend/v1.0.0/test-results.zip

aws lambda invoke --region=eu-west-2 --function-name=test-results