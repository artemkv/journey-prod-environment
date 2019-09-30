variable "project_id" {
  description = "Id of project"
  default     = "journey-250514"
}

variable "gcp_region" {
  description = "The region to launch services"
  default     = "europe-west1"
}

variable "node_instance_type" {
  description = "The instance type for the k8s node"
  default     = "g1-small"
}