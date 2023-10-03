resource "shoreline_notebook" "spark_executor_failure_during_job_execution" {
  name       = "spark_executor_failure_during_job_execution"
  data       = file("${path.module}/data/spark_executor_failure_during_job_execution.json")
  depends_on = [shoreline_action.invoke_spark_executor_avail_check,shoreline_action.invoke_resource_limits]
}

resource "shoreline_file" "spark_executor_avail_check" {
  name             = "spark_executor_avail_check"
  input_file       = "${path.module}/data/spark_executor_avail_check.sh"
  md5              = filemd5("${path.module}/data/spark_executor_avail_check.sh")
  description      = "Insufficient resources allocated to the Spark executor leading to failure during job execution."
  destination_path = "/agent/scripts/spark_executor_avail_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "resource_limits" {
  name             = "resource_limits"
  input_file       = "${path.module}/data/resource_limits.sh"
  md5              = filemd5("${path.module}/data/resource_limits.sh")
  description      = "Check if the executor has sufficient resources such as memory, CPU cores, and disk space. Increase the resources if necessary."
  destination_path = "/agent/scripts/resource_limits.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_spark_executor_avail_check" {
  name        = "invoke_spark_executor_avail_check"
  description = "Insufficient resources allocated to the Spark executor leading to failure during job execution."
  command     = "`chmod +x /agent/scripts/spark_executor_avail_check.sh && /agent/scripts/spark_executor_avail_check.sh`"
  params      = ["EXECUTOR_MEMORY","EXECUTOR_CORES"]
  file_deps   = ["spark_executor_avail_check"]
  enabled     = true
  depends_on  = [shoreline_file.spark_executor_avail_check]
}

resource "shoreline_action" "invoke_resource_limits" {
  name        = "invoke_resource_limits"
  description = "Check if the executor has sufficient resources such as memory, CPU cores, and disk space. Increase the resources if necessary."
  command     = "`chmod +x /agent/scripts/resource_limits.sh && /agent/scripts/resource_limits.sh`"
  params      = ["EXECUTOR_MEMORY","DISK_LIMIT","EXECUTOR_CORES","SPARK_HOME"]
  file_deps   = ["resource_limits"]
  enabled     = true
  depends_on  = [shoreline_file.resource_limits]
}

