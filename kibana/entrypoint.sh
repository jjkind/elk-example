#!/usr/bin/env bash
#
# echo "ELASTIC_PASSWORD="$ELASTIC_PASSWORD;
# echo "ELASTICSEARCH_PASSWORD="$ELASTICSEARCH_PASSWORD;
until curl -s --cacert config/certs/ca/ca.crt https://es01:9200 | grep -q "missing authentication credentials"; do echo "Waiting for Elasticsearch availability"; sleep 15; done;
echo "Setting kibana_system password";
until curl -s -X POST --cacert config/certs/ca/ca.crt -u elastic:${ELASTIC_PASSWORD} -H "Content-Type: application/json" https://es01:9200/_security/user/kibana_system/_password -d "{\"password\":\"${ELASTICSEARCH_PASSWORD}\"}" | grep -q "^{}"; do echo "Trying to set the password for kibana_system account"; sleep 10; done;
echo "Done setting password for Kibana."
echo "Starting Kibana.";
/bin/tini -s -- /usr/local/bin/kibana-docker;
