output "rds_endpoint" {
  value = "${aws_db_instance.server_db.endpoint}:${aws_db_instance.server_db.port}"
}

output "rds_instance_id" {
  value = aws_db_instance.server_db.id
}