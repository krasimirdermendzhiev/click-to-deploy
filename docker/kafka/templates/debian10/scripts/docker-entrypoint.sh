#!/bin/bash
#
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

# Clear some variables that we don't want runtime
unset KAFKA_USER KAFKA_UID KAFKA_GROUP KAFKA_GID \
      KAFKA_CLOSER_URL KAFKA_DIST_URL KAFKA_ARCHIVE_URL KAFKA_DOWNLOAD_URL KAFKA_DOWNLOAD_SERVER KAFKA_SHA512

if [[ "$VERBOSE" == "yes" ]]; then
    set -x
fi

if [[ -v KAFKA_PORT ]] && ! grep -E -q '^[0-9]+$' <<<"${KAFKA_PORT:-}"; then
  KAFKA_PORT=9092
  export KAFKA_PORT
fi

# when invoked with e.g.: docker run solr -help
if [ "${1:0:1}" == '-' ]; then
    set -- solr-foreground "$@"
fi

# execute command passed in as arguments.
# The Dockerfile has specified the PATH to include
# /opt/solr/bin (for Solr) and /opt/docker-solr/scripts (for our scripts
# like solr-foreground, solr-create, solr-precreate, solr-demo).
# Note: if you specify "solr", you'll typically want to add -f to run it in
# the foreground.
exec "$@"
