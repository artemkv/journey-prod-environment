# Set up state storage - where to store state file
terraform {
    backend "gcs" {
    # you cannot use variables in this block, that's why the values are "hard-coded"
    # what you can do is to provide these values when runninng "terraform init"
    # so ideally you should not put this data here to keep the template re-usable
    credentials = "key.json"
    bucket      = "journey-250514-tf-state"
    prefix      = "journey"
  }
}

# Set up the cloud provider - where to create resources
provider "google" {
  credentials = "${file("key.json")}"
  project     = "${var.project_id}"
  region      = "${var.gcp_region}"
}

# Topic to publish actions
resource "google_pubsub_topic" "action-topic" {
  name = "action-topic"

  labels = {
    app = "journey"
  }
}

# Topic to publish errors
resource "google_pubsub_topic" "error-topic" {
  name = "error-topic"

  labels = {
    app = "journey"
  }
}

# Subscription to receive actions
resource "google_pubsub_subscription" "action-subscription" {
  name  = "action-subscription"
  topic = "${google_pubsub_topic.action-topic.name}"

  labels = {
    app = "journey"
  }

  message_retention_duration = "604800s" # 7 days
  ack_deadline_seconds = 60
  retain_acked_messages = false

  expiration_policy {
    # If ttl is not set, the associated resource never expires
  }
}

# Subscription to receive errors
resource "google_pubsub_subscription" "error-subscription" {
  name  = "error-subscription"
  topic = "${google_pubsub_topic.error-topic.name}"

  labels = {
    app = "journey"
  }

  message_retention_duration = "604800s" # 7 days
  ack_deadline_seconds = 60
  retain_acked_messages = false

  expiration_policy {
    # If ttl is not set, the associated resource never expires
  }
}

# Account for events service
resource "google_service_account" "events-service-account" {
  account_id   = "events-service-account"
  display_name = "Events Service Account"
}

# Give event service a right to publish to action topic
resource "google_pubsub_topic_iam_binding" "events-service-publish-to-action" {
    project = "${var.project_id}"
    topic = "${google_pubsub_topic.action-topic.name}"
    role = "roles/pubsub.publisher"
    members = [
        "serviceAccount:${google_service_account.events-service-account.email}"
    ]
}

# Give event service a right to publish to error topic
resource "google_pubsub_topic_iam_binding" "events-service-publish-to-error" {
    project = "${var.project_id}"
    topic = "${google_pubsub_topic.error-topic.name}"
    role = "roles/pubsub.publisher"
    members = [
        "serviceAccount:${google_service_account.events-service-account.email}"
    ]
}

# TODO: split into a separate module

# Create GKE cluster
resource "google_container_cluster" "gke_cluster" {
  name     = "gke-cluster"
  location = "${var.gcp_region}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1
}

# Create GKE cluster node pool
resource "google_container_node_pool" "gke_cluster_node_pool" {
  name       = "gke-cluster-node-pool"
  location   = "${var.gcp_region}"
  cluster    = "${google_container_cluster.gke_cluster.name}"
  node_count = 1 # per zone

  node_config {
    preemptible  = true
    machine_type = "${var.node_instance_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}