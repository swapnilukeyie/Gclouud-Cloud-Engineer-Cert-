# 🔗 Datasets & Useful Links — GSP096

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Streaming Analytics into BigQuery | https://www.cloudskillsboost.google/course_templates/752 |
| Lab (GSP096): Pub/Sub Qwik Start - Console | https://www.cloudskillsboost.google/focuses/3719?parent=catalog |
| Pub/Sub Console | https://console.cloud.google.com/cloudpubsub |

## Tools & Services (deep-dive links)

| Tool | Link |
|---|---|
| Pub/Sub overview (what & why) | https://cloud.google.com/pubsub/docs/overview |
| Creating & managing topics | https://cloud.google.com/pubsub/docs/create-topic |
| Subscriptions overview (pull vs push) | https://cloud.google.com/pubsub/docs/subscription-overview |
| Acknowledgments & ack deadlines | https://cloud.google.com/pubsub/docs/lease-management |
| Replaying & seeking / snapshots | https://cloud.google.com/pubsub/docs/replay-overview |
| Dead-letter topics | https://cloud.google.com/pubsub/docs/handling-failures |
| `gcloud pubsub` command reference | https://cloud.google.com/sdk/gcloud/reference/pubsub |

## Datasets Used in This Lab

None — this lab creates its own data: a single `Hello World` message published to `MyTopic` and pulled through `MySub`.

### Objects created during the lab

| Object | Created in | Notes |
|---|---|---|
| Topic `MyTopic` | Task 1 | The named channel holding published messages |
| Subscription `MySub` | Task 2 | **Pull**-type; attached to MyTopic; created *before* publishing (required to receive the message) |
| Message `Hello World` | Task 4 | Published via the console Messages tab, pulled + acked via `gcloud` in Task 5 |

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full walkthrough with pipeline context, concepts, quiz answers, and pro tips |
| `solutions.sh` | Every step as a runnable gcloud command with console paths in comments |
| `datasets-and-links.md` | This file — references and links |
