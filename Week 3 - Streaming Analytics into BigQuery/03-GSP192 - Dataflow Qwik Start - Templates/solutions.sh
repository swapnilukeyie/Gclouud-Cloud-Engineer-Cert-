#!/bin/bash
# ============================================================================
# GSP192: Dataflow Qwik Start - Templates
# Builds a streaming Pub/Sub -> BigQuery pipeline from a Google-provided
# Dataflow template. Runs entirely in Cloud Shell (Task 2 path).
#
# *** Replace every <PLACEHOLDER> with YOUR lab's value ***
#   <PROJECT_ID>  = your qwiklabs-gcp-... project id
#   <REGION>      = your lab's region (e.g. us-central1) — appears TWICE in Task 4
#   <BUCKET_NAME> = the bucket you create (use the Project ID)
# ============================================================================


# ----------------------------------------------------------------------------
# SETUP: activate Cloud Shell (>_ icon -> Continue -> Authorize), then verify.
# ----------------------------------------------------------------------------
gcloud auth list
gcloud config list project


# ----------------------------------------------------------------------------
# TASK 1: Reset the Dataflow API (disable then re-enable) so the job launches
# cleanly. In normal work you'd just enable it once.
# ----------------------------------------------------------------------------
gcloud services disable dataflow.googleapis.com --project <PROJECT_ID> --force
gcloud services enable  dataflow.googleapis.com --project <PROJECT_ID>


# ----------------------------------------------------------------------------
# TASK 2: Create the destination dataset + table and the staging bucket.
# (Do EITHER Task 2 CLI here OR Task 3 in the console — not both.)
# ----------------------------------------------------------------------------

# 2a) dataset
bq mk taxirides

# 2b) table, partitioned by timestamp, schema matching the taxi-ride JSON.
#     The trailing backslashes make this one command across several lines.
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime

# 2c) staging bucket (Project ID = globally-unique name)
export BUCKET_NAME="<PROJECT_ID>"
gsutil mb gs://$BUCKET_NAME/
#   modern equivalent: gcloud storage buckets create gs://$BUCKET_NAME


# ----------------------------------------------------------------------------
# TASK 4: Launch the Pub/Sub -> BigQuery Dataflow template.
#   inputTopic      = the PUBLIC live taxi-ride topic
#   outputTableSpec = <PROJECT_ID>:taxirides.realtime  (colon after project)
# Watch it in: Navigation menu > View all products > Analytics > Dataflow > Jobs
# ----------------------------------------------------------------------------
gcloud dataflow jobs run iotflow \
    --gcs-location gs://dataflow-templates-<REGION>/latest/PubSub_to_BigQuery \
    --region <REGION> \
    --worker-machine-type e2-medium \
    --staging-location gs://<BUCKET_NAME>/temp \
    --parameters inputTopic=projects/pubsub-public-data/topics/taxirides-realtime,outputTableSpec=<PROJECT_ID>:taxirides.realtime


# ----------------------------------------------------------------------------
# TASK 5: Query the streaming data (wait ~1 min for the pipeline to warm up;
# re-run if the first attempt is empty or errors).
# ----------------------------------------------------------------------------
bq query --use_legacy_sql=false \
  'SELECT * FROM `<PROJECT_ID>.taxirides.realtime` LIMIT 1000'


# ----------------------------------------------------------------------------
# CLEANUP (own account only — streaming jobs bill until stopped!):
#   gcloud dataflow jobs list --region=<REGION> --status=active
#   gcloud dataflow jobs drain  <JOB_ID> --region=<REGION>   # clean stop
#   gcloud dataflow jobs cancel <JOB_ID> --region=<REGION>   # immediate stop
# ----------------------------------------------------------------------------
