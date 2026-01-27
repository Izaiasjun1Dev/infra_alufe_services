moved {
  from = null_resource.docker_build
  to   = module.ecr.null_resource.docker_build
}

moved {
  from = aws_iam_role_policy_attachment.lambda_dynamo
  to   = module.lambda.aws_iam_role_policy_attachment.lambda_dynamo
}

moved {
  from = aws_iam_role_policy_attachment.lambda_s3
  to   = module.lambda.aws_iam_role_policy_attachment.lambda_s3
}

moved {
  from = aws_iam_policy.lambda_bedrock
  to   = module.lambda.aws_iam_policy.lambda_bedrock
}

moved {
  from = aws_iam_role_policy_attachment.lambda_bedrock
  to   = module.lambda.aws_iam_role_policy_attachment.lambda_bedrock
}
