oc new-project che-dev-images  
oc policy add-role-to-group system:image-puller system:serviceaccounts -n che-dev-images
oc apply -f ./dev-container-build.yaml

oc import-image kafka:0.34.0-kafka-3.4.0 --from=quay.io/strimzi/kafka:0.34.0-kafka-3.4.0 --confirm -n che-dev-images
oc import-image mongodb:5.0 --from=docker.io/bitnami/mongodb:5.0 --confirm -n che-dev-images
oc import-image postgresql-15-c9s:c9s --from=quay.io/sclorg/postgresql-15-c9s:c9s --confirm -n che-dev-images

oc start-build dev-tools-image -n che-dev-images -w -F    
oc start-build dev-workspace-image-base -n che-dev-images -w -F
oc start-build dev-workspace-image-vfs -n che-dev-images -w -F
oc start-build dev-workspace-image-fuse -n che-dev-images -w -F
oc start-build dev-workspace-image-nested -n che-dev-images -w -F
