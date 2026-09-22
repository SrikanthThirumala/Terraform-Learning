
resource "aws_iam_role" "lambda_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name #attaching policy to role 
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "custom_lambda" {
  function_name = "my_lambda_function"
  role          =  aws_iam_role.lambda_role.arn 
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128
  filename = "lambda_function.zip"

 
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  #Without source_code_hash, Terraform might not 
  #detect when the code in the ZIP file has changed — 
  #meaning your Lambda might not update even after uploading a new ZIP.

}

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = "my-app-trigger-rule"
  description         = "Triggers Lambda periodically or on event"
  schedule_expression = "rate(5 minutes)" # Change to event_pattern if matching AWS events
}


resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "MyLambdaTarget"
  arn       = aws_lambda_function.custom_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.custom_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
}


# C:\Users\jpnsr>terraform workspace
# Usage: terraform [global options] workspace

#   new, list, show, select and delete Terraform workspaces.

# Subcommands:
#     delete    Delete a workspace
#     list      List Workspaces
#     new       Create a new workspace
#     select    Select a workspace
#     show      Show the name of the current workspace


#Lambda function python zip file fetched from s3 bucket 


resource "aws_s3_bucket" "lambda_function_bucket" {
  bucket = "lambda-function-bucket-sri"
  
  }

resource "aws_s3_object" "lamda_zip_file_object" {
  bucket = aws_s3_bucket.lambda_function_bucket.id
  key = "lambda/lambda_function.zip"
  source = "./lambda_function.zip"
  etag = filemd5("${path.module}/lambda_function.zip")#Automatically re-upload if the local file hash changes
}

  

resource "aws_lambda_function" "lambda_with_s3" {
  function_name = "Lambda_with_s3"
  role          =  aws_iam_role.lambda_role.arn 
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128

  s3_bucket = aws_s3_object.lamda_zip_file_object.bucket
  s3_key = aws_s3_object.lamda_zip_file_object.key

 
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  #Without source_code_hash, Terraform might not 
  #detect when the code in the ZIP file has changed — 
  #meaning your Lambda might not update even after uploading a new ZIP.

}