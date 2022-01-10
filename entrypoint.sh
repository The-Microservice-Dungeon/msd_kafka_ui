#!/bin/bash
# Docker entrypoint script.

/app/bin/kafka_ui eval "KafkaUi.Release.migrate"

exec $@
