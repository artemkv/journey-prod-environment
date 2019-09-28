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