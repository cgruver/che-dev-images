oc new-project che-dev-images  
oc policy add-role-to-group system:image-puller system:serviceaccounts -n che-dev-images
oc apply -f ./dev-container-build.yaml

oc start-build dev-tools-image -n che-dev-images -w -F    
oc start-build dev-workspace-image-base -n che-dev-images -w -F
oc start-build dev-workspace-image-vfs -n che-dev-images -w -F
oc start-build dev-workspace-image-fuse -n che-dev-images -w -F
oc start-build dev-workspace-image-nested -n che-dev-images -w -F
oc start-build dev-podman-image -n che-dev-images -w -F
