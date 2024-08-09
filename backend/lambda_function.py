import boto3
import logging

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
	logging.info('AWS Lambda function processed a request.')
	
	#added CORS headers
	headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': '*',
        'Access-Control-Allow-Headers': 'Content-Type'
    }

	try:
		# Extract table name from the event body
		table_name = event['tableName']
		partition_key = "key"
		partition_key_value = "visitor_count"
		counter_attribute = "counter"

		# Get the DynamoDB table
		table = dynamodb.Table(table_name)

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