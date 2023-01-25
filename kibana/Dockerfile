ARG VERSION

FROM docker.elastic.co/kibana/kibana:${VERSION}

# Update packages
USER root
RUN apt-get update && apt-get upgrade -y && apt-get install -y unzip

# Create all the certificates needed for each cluster member
COPY ca.zip config/certs/
RUN unzip config/certs/ca.zip -d config/certs
RUN chown -R root:root config/certs \
    && ls -la config/certs
    # && find . -type d -exec chmod 750 \{\} \; \
    # && find . -type f -exec chmod 640 \{\} \; \


# Copy the entrypoint script and set it to executeable and to the CMD to be 
COPY ./kibana/entrypoint.sh .
RUN chmod u+x entrypoint.sh

USER kibana


ENTRYPOINT ./entrypoint.sh
