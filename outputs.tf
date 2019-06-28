output "rds_endpoint" {
  value = "${aws_rds_cluster.rds_cluster.endpoint}"
}
