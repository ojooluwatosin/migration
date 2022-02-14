// create the subnet group for RDS instance
resource "aws_db_subnet_group" "dms-rds-subnet-group" {
  name = "dms-rds-subnet-group"
  subnet_ids = [
    "${aws_subnet.dms-subnet.id}",
    "${aws_subnet.dms-subnet-2.id}"
  ]
}
// create the parameter group (### There is a bug here that would not allow us to create a db_cluster_parameter_group_name without creating a parameter group in the first place)
resource "aws_rds_cluster_parameter_group" "default" {
  name        = "aurora-postgresql10"
  family      = "aurora-postgresql12"
  description = "RDS default cluster parameter group"
}
// create the RDS cluster
resource "aws_rds_cluster" "aws_rds_cluster_dms" {
  backup_retention_period         = "7"
  cluster_identifier              = "aurora-dms"
  db_cluster_parameter_group_name = "default.aurora-postgresql10"
  db_subnet_group_name            = aws_db_subnet_group.dms-rds-subnet-group.id
  deletion_protection             = "false"
  engine                          = "aurora-postgresql"
  engine_mode                     = "provisioned"
  engine_version                  = "12.4"
  database_name                   = "postgres" #(### this database_name is required when connecting even though it is mandatory to create a database with database_name)
  master_password                 = var.db_password
  master_username                 = var.db_username
  port                            = "5432"
  skip_final_snapshot             = true
}
// create the RDS instance
resource "aws_rds_cluster_instance" "aws_db_instance_dms" {
  auto_minor_version_upgrade = "true"
  publicly_accessible        = "false"
  monitoring_interval        = "0"
  instance_class             = "db.r5.large"
  cluster_identifier         = aws_rds_cluster.aws_rds_cluster_dms.id
  identifier                 = "aurora-1-instance-1"
  db_subnet_group_name       = aws_db_subnet_group.dms-rds-subnet-group.id
  engine                     = "aurora-postgresql"
  engine_version             = "12.4"
}