ARG VERSION

FROM docker.elastic.co/logstash/logstash:${VERSION}

# Update packages
USER root
RUN apt-get update && apt-get upgrade -y && apt-get install -y unzip

# Create all the certificates needed for each cluster member
COPY *.zip config/certs/
RUN unzip config/certs/ca.zip -d config/certs
RUN unzip config/certs/certs.zip -d config/certs;
RUN chown -R root:root config/certs \
    && ls -la config/certs

# Convert the logstash keys so that the beats input module can use it
RUN openssl pkcs8 -in config/certs/logstash01/logstash01.key -topk8 -nocrypt -out config/certs/logstash01/logstash01.pkcs8.key
RUN openssl pkcs8 -in config/certs/logstash02/logstash02.key -topk8 -nocrypt -out config/certs/logstash02/logstash02.pkcs8.key
RUN openssl pkcs8 -in config/certs/logstash03/logstash03.key -topk8 -nocrypt -out config/certs/logstash03/logstash03.pkcs8.key

# Copy the configuration files 
COPY ./logstash/logstash.conf config/
COPY ./logstash/logstash.yml config/

# Copy the entrypoint script and set it to executeable and to the CMD to be 
COPY ./logstash/entrypoint.sh .
RUN chown logstash entrypoint.sh
RUN chmod u+x entrypoint.sh

# Run as the logstash user and NOT root
USER logstash

ENTRYPOINT ./entrypoint.sh
