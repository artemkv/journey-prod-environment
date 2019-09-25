# Set up state storage - where to store state file
terraform {
  backend "gcs" {
    credentials = "key.json"
    bucket  = "journey-250514-tf-state"
    prefix  = "journey"
  }
}

# Set up the cloud provider - where to create resources
provider "google" {
  credentials = "${file("key.json")}"
  project     = "journey-250514"
  region      = "europe-west1"
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

output "action-topic-name" {
  value = google_pubsub_topic.action-topic.id
}

output "action-subscription-name" {
  value = google_pubsub_subscription.action-subscription.id
}

output "error-topic-name" {
  value = google_pubsub_topic.error-topic.id
}

output "error-subscription-name" {
  value = google_pubsub_subscription.error-subscription.id
}