import json
import boto3
import requests
from requests_aws4auth import AWS4Auth

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('MyTable')

def lambda_handler(event, context):
    print("Lambda function executed successfully.")

    r = requests.get('https://jsonplaceholder.typicode.com/todos/1')
    print(r.json())

    credentails = boto3.Session().get_credentials()
    auth = AWS4Auth(credentails.access_key, credentails.secret_key, 'ap-south-1', 'dynamodb', session_token=credentails.token)
    print(auth)
    return {
        'statusCode': 200,
        'body': 'Hello from MyPython Lambda!'
    }