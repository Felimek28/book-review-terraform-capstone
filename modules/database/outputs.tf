# Connection endpoint for the provisioned RDS instance.
output "db_endpoint" {
  value = aws_db_instance.book_review_db.endpoint
}
output "replica_endpoint" {
  description = "Endpoint of the RDS read replica"
  value       = aws_db_instance.book_review_db_replica.endpoint
}