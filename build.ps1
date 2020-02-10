# aws s3 mb s3://cvs-spike-backend --region eu-west-2 --endpoint-url https://s3.eu-west-2.amazonaws.com

zip -D -j .\cvs-spike-backend\test-results.zip .\cvs-spike-backend\test-results\main.js
aws s3 cp .\cvs-spike-backend\test-results.zip s3://cvs-spike-backend/v1.0.0/test-results.zip

zip -D -j .\cvs-spike-backend\event.completed-tests.stage-data.zip .\cvs-spike-backend\event.completed-tests.stage-data\main.js
aws s3 cp .\cvs-spike-backend\event.completed-tests.stage-data.zip s3://cvs-spike-backend/v1.0.0/event.completed-tests.stage-data.zip

aws lambda invoke --region=eu-west-2 --function-name=test-results results.txt
Get-Content results.txt
