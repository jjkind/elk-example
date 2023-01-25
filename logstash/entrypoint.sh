#!/usr/bin/env bash
#
# Try and create the logstash write role
until \
    curl -s -X POST --cacert config/certs/ca/ca.crt -u elastic:${ELASTIC_PASSWORD} -H "Content-Type: application/json" \
    https://es01:9200/_security/role/logstash_write_role --data \
    '{
        "cluster": [
        "monitor",
        "manage_index_templates"
        ],
        "indices": [
        {
            "names": [
            "logstash*"
            ],
            "privileges": [
            "write",
            "create_index"
            ],
            "field_security": {
            "grant": [
                "*"
            ]
            }
        }
        ],
        "run_as": [],
        "metadata": {},
        "transient_metadata": {
        "enabled": true
        }
    }' | grep -q '^{"role"'; 
do echo "Trying to set the write role for logstash"; sleep 10; done;
echo "Logstash write role successfully created";
#
# Try and create the logstash write user
until \
    curl -s -X POST --cacert config/certs/ca/ca.crt -u elastic:${ELASTIC_PASSWORD} -H "Content-Type: application/json" \
    https://es01:9200/_security/user/logstash_writer --data \
    '{
        "username": "logstash_writer",
        "roles": [
            "logstash_write_role"
        ],
        "full_name": null,
        "email": null,
        "password": "${LOGSTASH_WRITER_PASSWORD}",
        "enabled": true
    }' | grep -q '^{"created"'; 
do echo "Trying to create the write user for logstash"; sleep 10; done;
echo "Logstash write user successfully created";
# #
# # Try and set the logstash_system password which is needed to enable monitoring of the logstash instances, using xpack
# until \
#     curl -s -X POST --cacert config/certs/ca/ca.crt -u elastic:${ELASTIC_PASSWORD} -H "Content-Type: application/json" \
#     https://es01:9200/_security/user/logstash_system/_password -d "{\"password\":\"${LOGSTASH_SYSTEM_PASSWORD}\"}" | grep -q "^{}"; do echo "Trying to set the password for logstash_system account"; sleep 10; done;
# echo "logstash_system account password has been set successfully."
echo "Starting Logstash.";
/usr/local/bin/docker-entrypoint;
