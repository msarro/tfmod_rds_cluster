variable "subnet_ids" {
  description = "A list of subnets by ID that make up the database subnet group."
  type        = "list"
}

variable "environment" {
  description = "The environment for the subnet group."
}

variable "db_engine" {
  description = "The RDS database engine to use."
  default     = "aurora-mysql"
}

variable "database_name" {
  description = "The name of the RDS database."
}

variable "database_master" {
  description = "The master username of the RDS database."
}

variable "database_pass" {
  description = "The master password of the RDS database."
}

variable "backup_duration" {
  description = "The retention period for backup, in days."
}

variable "backup_window" {
  description = "The preferred backup window for the database."
  default     = "07:00-09:00"
}

variable "rds_security_group_ids" {
  description = "The security groups to be associated with RDS."
  type        = "list"
}

variable "rds_instance_count" {
  description = "The number of database instances that should be created."
}

variable "rds_instance_class" {
  description = "The instance type for our RDS nodes"
  default     = "db.t2.small"
}

variable "rds_autoscaling_min" {
  description = "The minimum number of read replicas in the database."
  default     = 1
}

variable "rds_autoscaling_max" {
  description = "The maximum number of read replicas in the database."
  default     = 10
}

variable "rds_autoscaling_target_cpu" {
  description = "The CPU percentage at which another read replica should be added."
  default     = 75
}

variable "rds_autoscaling_scale_in_cooldown" {
  description = "The minimum amount of time below theshold before decommissioning a read replica."
  default     = 300
}

variable "rds_autoscaling_scale_out_cooldown" {
  description = "The amount of time CPU utilization must exceed the target to commission new read replica"
  default     = 300
}
