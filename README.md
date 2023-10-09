# WissKI

This repo is based on the [Docker WissKI](https://github.com/rnsrk/dockerWissKI.git "Docker WissKI") and contains configuration files needed for creating deployment pipeline based on GitHub actions that builds WissKI Drupal Docker image and deploys it together with official [GraphDB](https://hub.docker.com/r/ontotext/graphdb "Graphdb") and [Solr](https://hub.docker.com/_/solr/ "Solr") Docker images as WissKI stack to ACDH-CH Kubernetes environment. 

Due to specific ACDH-CH environment that is using centralized MariaDB, dedicated MariaDB Docker image is not used with this setup.

Environment variables needed for WissKI stack

|Name|Required|Type|Level|Description|
|----|:------:|----|:---:|-----------|
|KUBE_CONFIG|:white_check_mark:|Secret|Org|base64 encoded K8s config file. Usually set at the Org level and shared by all (public) repositories. |
|C2_KUBE_CONFIG|:white_check_mark:|Secret|Org|If you deploy using the workflow for the second cluster the C2_ variant is used. |
|KUBE_NAMESPACE|:white_check_mark:|Variable|Repo/Env|The K8s namespace the deployment should be installed to. |
|DRUPAL_PUBLIC_URL|:white_check_mark:|Variable|Env|The URI that should be configured for access to the service. |
|DRUPAL_SERVICE_ID|:white_check_mark:|Variable|Env|A K8s label ID is attached to the workload/deployment with this value (usually a number) |
|GRAPHDB_PUBLIC_URL|:white_check_mark:|Variable|Env|The URI that should be configured for access to the service |
|GRAPHDB_SERVICE_ID|:white_check_mark:|Variable|Env|A K8s label ID is attached to the workload/deployment with this value (usually a number) |
|SOLR_PUBLIC_URL|:white_check_mark:|Variable|Env|The URI that should be configured for access to the service |
|SOLR_SERVICE_ID|:white_check_mark:|Variable|Env|A K8s label ID is attached to the workload/deployment with this value (usually a number) |
|K8S_SECRET_MARIADB_HOST|:white_check_mark:|Secret|Repo/Env|Hostname of an external MariaDB service. |
|K8S_SECRET_MARIADB_PORT|:white_check_mark:|Secret|Repo/Env|Port of an external MariaDB service. |
|K8S_SECRET_MARIADB_USER|:white_check_mark:|Secret|Env|Username for the MariaDB database. |  
|K8S_SECRET_MARIADB_PASSWORD|:white_check_mark:|Secret|Env|Password for the MariaDB database. |
|K8S_SECRET_MARIADB_DATABASE|:white_check_mark:|Secret|Env|Name of the MariaDB database to use. |  
|auth|:white_check_mark:|Secret|Env|Should be set over the Rancher. Credentials for protecting Solr with Nginx basic auth. Needed if Solr will use public URL. | 

### How to deploy new WissKI instance

1. Create Kubernetes namespace.
2. Create MariaDB database.
3. Create domains for Drupal, Solr and GraphDB and point them to the cluster.
4. Create new GitHub environment for the service that should have the same name as new GitHub branch that will be used for the new WissKI instance.
5. Add GitHub environment variables and secrets described in the table above.
6. Create a new branch in this repo that should have tha same name as the Kubernetes namespace created in the first step.
7. Create auth Secret for the Solr basic authentication if Solr needs public domain.
8. The newly created GitHub branch will trigger the Github pipeline that will deploy new WissKI stack to the Kubernetes Cluster.
9. Open Drupal and GraphDB domains and install Drupal and the Graphdb.