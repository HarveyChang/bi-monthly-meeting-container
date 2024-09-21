# variable "project_id" {
#   description = "The GCP project ID"
#   type        = string
# }

variable "region" {
  description = "The region to deploy resources in"
  type        = string
  default     = "asia-east1"
}

variable "zone" {
  description = "The zone to deploy resources in"
  type        = string
  default     = "asia-east1-a"
}

variable "machine_type" {
  description = "The type of machine to create"
  type        = string
  default     = "e2-medium"
}
