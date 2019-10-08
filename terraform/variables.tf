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

variable "kubernetes_ns" {
  description = "Kubernetes namespace where micro-services run"
  default     = "default"
}

variable "events-service-k8s-account" {
  description = "Kubernetes service account for events-service"
  default     = "events-service-account"
}

variable "stats-service-k8s-account" {
  description = "Kubernetes service account for stats-service"
  default     = "stats-service-account"
}