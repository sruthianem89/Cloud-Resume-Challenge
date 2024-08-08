import os
import boto3
import logging

# DynamoDB connection details
table_name = os.environ['DYNAMODB_TABLE_NAME']
partition_key = "key"
partition_key_value = "visitor_count"
counter_attribute = "counter"

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
	logging.info('AWS Lambda function processed a request.')

	try:
		# Retrieve the entity from the table
		response = table.get_item(Key={partition_key: partition_key_value})
		item = response.get('Item')

		if item:
			# Increment the counter
			counter = item[counter_attribute] + 1
			item[counter_attribute] = counter

			# Update the entity in DynamoDB
			table.put_item(Item=item)

			# Return the counter as a plain text response
			return {
				'statusCode': 200,
				'body': str(counter)
			}
		else:
			return {
				'statusCode': 404,
				'body': "Visitor count not found."
			}
	except Exception as e:
		logging.error(f"Error retrieving or updating entity: {e}")
		return {
			'statusCode': 500,
			'body': "Error retrieving or updating visitor count."
		}