resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "employee-mgnt/rds-credentials"
}


resource "aws_secretsmanager_secret_version" "admin" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode(var.secrets)
}

resource "aws_iam_policy" "secrets_read" {
  name = "TerraformSecretsRead"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.rds_credentials.arn
      }
    ]
  })
}