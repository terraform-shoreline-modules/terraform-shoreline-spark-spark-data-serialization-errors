resource "shoreline_notebook" "spark_data_serialization_errors" {
  name       = "spark_data_serialization_errors"
  data       = file("${path.module}/data/spark_data_serialization_errors.json")
  depends_on = [shoreline_action.invoke_data_processing_script,shoreline_action.invoke_data_encoding_conversion]
}

resource "shoreline_file" "data_processing_script" {
  name             = "data_processing_script"
  input_file       = "${path.module}/data/data_processing_script.sh"
  md5              = filemd5("${path.module}/data/data_processing_script.sh")
  description      = "The data being processed contains null values or missing data, causing serialization errors."
  destination_path = "/tmp/data_processing_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "data_encoding_conversion" {
  name             = "data_encoding_conversion"
  input_file       = "${path.module}/data/data_encoding_conversion.sh"
  md5              = filemd5("${path.module}/data/data_encoding_conversion.sh")
  description      = "Check the data source for any encoding issues and ensure that the data is properly formatted."
  destination_path = "/tmp/data_encoding_conversion.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_data_processing_script" {
  name        = "invoke_data_processing_script"
  description = "The data being processed contains null values or missing data, causing serialization errors."
  command     = "`chmod +x /tmp/data_processing_script.sh && /tmp/data_processing_script.sh`"
  params      = ["SPARK_CONF_FILE_PATH","DATA_FILE_PATH"]
  file_deps   = ["data_processing_script"]
  enabled     = true
  depends_on  = [shoreline_file.data_processing_script]
}

resource "shoreline_action" "invoke_data_encoding_conversion" {
  name        = "invoke_data_encoding_conversion"
  description = "Check the data source for any encoding issues and ensure that the data is properly formatted."
  command     = "`chmod +x /tmp/data_encoding_conversion.sh && /tmp/data_encoding_conversion.sh`"
  params      = ["DATA_FILE_PATH"]
  file_deps   = ["data_encoding_conversion"]
  enabled     = true
  depends_on  = [shoreline_file.data_encoding_conversion]
}

