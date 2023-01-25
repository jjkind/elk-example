ARG VERSION

FROM docker.elastic.co/elasticsearch/elasticsearch:${VERSION}

# Update and upgrade packages
USER root
RUN apt-get update && apt-get upgrade -y

# Create all the certificates needed for each cluster member
COPY *.zip config/certs/
RUN unzip config/certs/ca.zip -d config/certs
RUN unzip config/certs/certs.zip -d config/certs;
RUN chown -R root:root config/certs \
    && ls -la config/certs

USER elasticsearch