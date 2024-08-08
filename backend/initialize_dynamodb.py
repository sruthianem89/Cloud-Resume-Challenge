import os
import boto3

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE_NAME']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
	# Check if the counter exists
	response = table.get_item(Key={'key': 'visitor_count'})
	if 'Item' not in response:
		# Initialize the counter to 0 if it does not exist
		table.put_item(Item={'key': 'visitor_count', 'counter': 0})
	else:
		# If the counter exists and is non-zero, do nothing
		counter_value = response['Item'].get('counter', 0)
		if counter_value == 0:
			table.put_item(Item={'key': 'visitor_count', 'counter': 0})
	
	return {
		'statusCode': 200,
		'body': 'Initialization complete'
	}