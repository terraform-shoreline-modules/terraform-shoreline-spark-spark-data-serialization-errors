resource "shoreline_notebook" "spark_data_serialization_errors" {
  name       = "spark_data_serialization_errors"
  data       = file("${path.module}/data/spark_data_serialization_errors.json")
  depends_on = [shoreline_action.invoke_serialization_error_script,shoreline_action.invoke_check_spark_serialization,shoreline_action.invoke_spark_upgrade]
}

resource "shoreline_file" "serialization_error_script" {
  name             = "serialization_error_script"
  input_file       = "${path.module}/data/serialization_error_script.sh"
  md5              = filemd5("${path.module}/data/serialization_error_script.sh")
  description      = "Inspect the data causing the serialization error"
  destination_path = "/agent/scripts/serialization_error_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_spark_serialization" {
  name             = "check_spark_serialization"
  input_file       = "${path.module}/data/check_spark_serialization.sh"
  md5              = filemd5("${path.module}/data/check_spark_serialization.sh")
  description      = "Incompatibility between the Spark version and the data serialization library used."
  destination_path = "/agent/scripts/check_spark_serialization.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "spark_upgrade" {
  name             = "spark_upgrade"
  input_file       = "${path.module}/data/spark_upgrade.sh"
  md5              = filemd5("${path.module}/data/spark_upgrade.sh")
  description      = "Upgrade spark version to the latest stable release."
  destination_path = "/agent/scripts/spark_upgrade.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_serialization_error_script" {
  name        = "invoke_serialization_error_script"
  description = "Inspect the data causing the serialization error"
  command     = "`chmod +x /agent/scripts/serialization_error_script.sh && /agent/scripts/serialization_error_script.sh`"
  params      = ["DATA_THAT_CAUSED_SERIALIZATION_ERROR"]
  file_deps   = ["serialization_error_script"]
  enabled     = true
  depends_on  = [shoreline_file.serialization_error_script]
}

resource "shoreline_action" "invoke_check_spark_serialization" {
  name        = "invoke_check_spark_serialization"
  description = "Incompatibility between the Spark version and the data serialization library used."
  command     = "`chmod +x /agent/scripts/check_spark_serialization.sh && /agent/scripts/check_spark_serialization.sh`"
  params      = ["VERSION","LIBRARY","PATH_TO_SPARK_LOGS"]
  file_deps   = ["check_spark_serialization"]
  enabled     = true
  depends_on  = [shoreline_file.check_spark_serialization]
}

resource "shoreline_action" "invoke_spark_upgrade" {
  name        = "invoke_spark_upgrade"
  description = "Upgrade spark version to the latest stable release."
  command     = "`chmod +x /agent/scripts/spark_upgrade.sh && /agent/scripts/spark_upgrade.sh`"
  params      = ["VERSION"]
  file_deps   = ["spark_upgrade"]
  enabled     = true
  depends_on  = [shoreline_file.spark_upgrade]
}

