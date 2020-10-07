data "aws_availability_zones" "available" {
  state = "available"
}

output "azs" {
  value = data.aws_availability_zones.available.names
}

output "azs_length" {
  value = length(data.aws_availability_zones.available.names)
}