# 🔗 Datasets & Useful Links — GSP192

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge Course: Streaming Analytics into BigQuery | https://www.cloudskillsboost.google/course_templates/752 |
| Lab (GSP192): Dataflow Qwik Start - Templates | https://www.cloudskillsboost.google/focuses/1156?parent=catalog |
| Dataflow Console | https://console.cloud.google.com/dataflow |

## Tools & Services (deep-dive links)

| Tool | Link |
|---|---|
| Dataflow overview | https://cloud.google.com/dataflow/docs/overview |
| Get started with Google-provided templates | https://cloud.google.com/dataflow/docs/templates/provided-templates |
| Pub/Sub to BigQuery template (this lab) | https://cloud.google.com/dataflow/docs/templates/provided-templates#cloudpubsubtobigquery |
| Classic vs Flex templates | https://cloud.google.com/dataflow/docs/concepts/dataflow-templates |
| `gcloud dataflow jobs run` reference | https://cloud.google.com/sdk/gcloud/reference/dataflow/jobs/run |
| Stopping a pipeline (drain vs cancel) | https://cloud.google.com/dataflow/docs/guides/stopping-a-pipeline |
| `bq` CLI reference (schema syntax) | https://cloud.google.com/bigquery/docs/reference/bq-cli-reference |
| Apache Beam (the SDK under Dataflow) | https://beam.apache.org/ |

## Datasets Used in This Lab

### 1. Public taxi-ride stream — *pipeline source*
- **Pub/Sub topic:** `projects/pubsub-public-data/topics/taxirides-realtime`
- **What it is:** A Google-hosted **public streaming topic** emitting live NYC taxi-ride events as JSON (ride_id, lat/long, timestamp, meter reading, passenger count, ride status…). A famous demo firehose for streaming pipelines.

### 2. Objects created during the lab

| Object | Created in | Notes |
|---|---|---|
| BigQuery dataset `taxirides` | Task 2/3 | Holds the destination table |
| BigQuery table `taxirides.realtime` | Task 2/3 | **Partitioned by `timestamp`**; 9-field schema matching the taxi JSON |
| Cloud Storage bucket (Project ID) | Task 2/3 | Dataflow staging location (`gs://<bucket>/temp`) |
| Dataflow job `iotflow` | Task 4 | The running streaming pipeline (Pub/Sub → BigQuery template) |

> ⚠️ The Dataflow job is a **streaming** job — it keeps running and billing until drained/cancelled. Lab projects are torn down automatically.

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full walkthrough — pipeline story, both setup methods, concepts, quiz answers, pro tips |
| `solutions.sh` | Every command with `<PLACEHOLDER>` markers and cleanup commands |
| `datasets-and-links.md` | This file — references and links |
