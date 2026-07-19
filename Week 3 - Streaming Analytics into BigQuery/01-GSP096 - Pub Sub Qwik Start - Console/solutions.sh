#!/bin/bash
# ============================================================================
# GSP096: Pub/Sub Qwik Start - Console
# The lab is console-first; every console step's CLI equivalent is included
# so the whole thing can also be completed from Cloud Shell.
# ============================================================================


# ----------------------------------------------------------------------------
# SETUP: activate Cloud Shell (>_ icon -> Continue -> Authorize), then verify.
# ----------------------------------------------------------------------------
gcloud auth list            # ACTIVE: * ACCOUNT: student-XX-...@qwiklabs.net
gcloud config list project  # [core] project = qwiklabs-gcp-XX-...


# ----------------------------------------------------------------------------
# TASK 1: Create the topic.
# Console: Navigation menu > View All Products > Analytics > Pub/Sub > Topics
#          > Create topic > Topic ID: MyTopic > Create
# ----------------------------------------------------------------------------
gcloud pubsub topics create MyTopic

gcloud pubsub topics list   # verify


# ----------------------------------------------------------------------------
# TASK 2: Create a PULL subscription attached to the topic.
# Console: Topics > three dots next to MyTopic > Create subscription
#          > ID: MySub, Delivery Type: Pull > Create
# NOTE: create the subscription BEFORE publishing — messages published
# before a subscription exists are never delivered to it.
# ----------------------------------------------------------------------------
gcloud pubsub subscriptions create MySub --topic=MyTopic

gcloud pubsub subscriptions list   # verify


# ----------------------------------------------------------------------------
# TASK 4: Publish a message (the producer side).
# Console: Topics > MyTopic > Messages tab > Publish Message > "Hello World"
# ----------------------------------------------------------------------------
gcloud pubsub topics publish MyTopic --message="Hello World"


# ----------------------------------------------------------------------------
# TASK 5: Pull the message through the subscription (the consumer side).
# --auto-ack acknowledges in the same step; without it the message would
# re-deliver after the ack deadline (default 10 s).
# The message appears in the DATA field of the output.
# ----------------------------------------------------------------------------
gcloud pubsub subscriptions pull --auto-ack MySub


# ----------------------------------------------------------------------------
# CLEANUP (own account only — lab projects are discarded automatically):
# ----------------------------------------------------------------------------
# gcloud pubsub subscriptions delete MySub
# gcloud pubsub topics delete MyTopic
