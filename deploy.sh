docker login cmd.azurecr-test.io -u commands -p k0k/gCDhkLbW=yjV1XflLZJH/T3Aw/yO
#!/bin/sh

set -e
# SP, PASSWORD , CLUSTER_NAME, CLUSTER_RESOURCE_GROUP
az configure --defaults acr=$RUN_REGISTRYNAME

az login \
    --service-principal \
    --username $SP \
    --password $PASSWORD \
    --tenant $TENANT  > /dev/null

az aks get-credentials \
    -g $CLUSTER_RESOURCE_GROUP \
    -n $CLUSTER_NAME 

echo -- helm init  --
helm init  # > /dev/null

echo -- az acr helm repo add --
az acr helm repo add 

echo -- helm fetch $REGISTRY_NAME/importantThings --
helm fetch $REGISTRY_NAME/importantThings

echo -- helm upgrade demo42 ./helm/importantThings --
helm upgrade demo42 ./helm/importantThings 
      --reuse-values 
      --set queueworker.image={{.Run.Registry}}/demo42/queueworker:$RUN_ID
