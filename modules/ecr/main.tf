resource "aws_ecr_repository" "repo" {
  name                 = "${var.project_name}-${var.environment}-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Automated Docker Build & Push
resource "null_resource" "docker_build" {
  count = var.build_image ? 1 : 0

  triggers = {
    workflow_hash = var.image_tag
  }

  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${split("/", aws_ecr_repository.repo.repository_url)[0]}
      docker build -t ${aws_ecr_repository.repo.repository_url}:${var.image_tag} ../back
      docker push ${aws_ecr_repository.repo.repository_url}:${var.image_tag}
    EOF
  }
}
