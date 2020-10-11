output "jenkins-id" {
  value = aws_instance.jenkins.id
}

output "jenkins-public-dns" {
  value = aws_instance.jenkins.public_dns
}


output "test-environment-id" {
  value = aws_instance.test-environment.id
}

output "test-public-dns" {
  value = aws_instance.test-environment.public_dns
}


output "production-endpoint" {
  value = aws_db_instance.production-db.endpoint
}

output "testdb-endpoint" {
  value = aws_db_instance.test-db.endpoint
}

output "production-db-password" {
  value       = aws_db_instance.production-db.password
  description = "The password for logging in to the database."
  sensitive   = true
}

output "test-db-password" {
  value       = aws_db_instance.test-db.password
  description = "The password for logging in to the test  database."
  sensitive   = true
}
