# Clustered ELK stack
The documentation below is based on the Elastic published document at: https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html. It has been heavily modified to make it work in a swarm. The actual example only worked in a single docker node.

Another good document found was: https://www.elastic.co/blog/configuring-ssl-tls-and-https-to-secure-elasticsearch-kibana-beats-and-logstash


The main changes are:
1.  Use custom Elastic & Kibana images to deploy the certificates needed for the cluster to work
1.  The Kibana image uses a custom entrypoint.sh script to wait for the elastic nodes to be ready, set the Kibana password and then start Kibana
1.  Use deployment constraints to prevent the elastic nodes being deployed on the same docker node

## Running on a single docker node
Comment out the deployment constraints before deploying on a single docker node as it will be looking for specific labels 

## Creating the certs used in the deployment
To create the certificates used, run the docker-compose-create-certs.yml file with the following command. A bind mount volume is used to put the certificates in. Once it runs, copy the certificates into this repository at the top level and proceed to build the images for elastic and kibana.
```
docker-compose -f docker-compose-create-certs.yml up
```

## Building the images and putting them in the registry
The following commands build and push the image to the local registry
```
docker-compose build
docker-compose push
```

## Running on a Docker Swarm
Use the following command to run an elastic cluster on a docker swarm management node. The docke-compose.yml file in this repo assumes that each node in the swarm is labelled as some services are constrained to run on particular nodes to ensure there is no single point of failure or overloading.
```
docker stack deploy -c docker-compose.yml <stack name>
```

<!-- ## Finding the entrypoint to the images to use in command scripts
There is a dependency relationship between some of the containers and this needs to be modelled in order for it to deploy successfully in a docker swarm. Command scripts in the docker-compose.yml file are used for this purpose. In order to find the entrypoint of the image use the following command.
```
docker image inspect <image name here>
```
Then look in the ouput for the following information, see example below.
```
            "Entrypoint": [
                "/bin/tini",
                "--",
                "/usr/local/bin/docker-entrypoint.sh"
            ],
```
This information is then used in the command scripts to wait for another container to start and then call the appropriate entry point. See the docker-compose file command option to see an example of the script and then the invocation of the entry point. -->

## Service Startup Dependencies
1.  Each of the elastic nodes should start in parallel and after a period of time form a cluster.
1.  The Kibana container will wait for one of the cluster members to start and return a message, before trying to set the password for the kibana_system account. After the password is set Kibana itself will start.

## Login to Kibana
Use any of the swarm nodes url to get to kibana. For example on a 3 node swarm (docker01,docker02,docker03) the url would be http://docker02:5601. At the Kibanan login screen use the username of elastic and the password set in the secret called ELASTIC_PASSWORD.

## TODO
1.  Convert all passwords to secrets
1.  Determine if the elastic containers need the elastic password

