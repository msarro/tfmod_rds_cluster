resource "aws_db_subnet_group" "db_subnet" {
  name = "${var.environment}_db_subnet"

  subnet_ids = ["${var.subnet_ids}"]

  tags {
    Name = "${var.environment} RDS Subnet Group"
  }
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier      = "rds-cluster"
  engine                  = "${var.db_engine}"
  db_subnet_group_name    = "${aws_db_subnet_group.db_subnet.id}"
  database_name           = "${var.database_name}"
  master_username         = "${var.database_master}"
  master_password         = "${var.database_pass}"
  backup_retention_period = "${var.backup_duration}"
  preferred_backup_window = "${var.backup_window}"
  skip_final_snapshot     = true
  vpc_security_group_ids  = ["${var.rds_security_group_ids}"]
}

resource "aws_rds_cluster_instance" "rds_cluster_instances" {
  count                = "${var.rds_instance_count}"
  identifier           = "${var.environment}-rds-cluster-instance-${count.index}"
  cluster_identifier   = "${aws_rds_cluster.rds_cluster.id}"
  instance_class       = "${var.rds_instance_class}"
  engine               = "${var.db_engine}"
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet.id}"
}

resource "aws_appautoscaling_target" "rds_read_replicas" {
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "cluster:${aws_rds_cluster.rds_cluster.id}"
  min_capacity       = "${var.rds_autoscaling_min}"
  max_capacity       = "${var.rds_autoscaling_max}"
}

resource "aws_appautoscaling_policy" "rds_cpu_auto_scaling" {
  name               = "rds_cpu_auto_scaling"
  service_namespace  = "${aws_appautoscaling_target.rds_read_replicas.service_namespace}"
  scalable_dimension = "${aws_appautoscaling_target.rds_read_replicas.scalable_dimension}"
  resource_id        = "${aws_appautoscaling_target.rds_read_replicas.resource_id}"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }

    target_value       = "${var.rds_autoscaling_target_cpu}"
    scale_in_cooldown  = "${var.rds_autoscaling_scale_in_cooldown}"
    scale_out_cooldown = "${var.rds_autoscaling_scale_out_cooldown}"
  }
}
