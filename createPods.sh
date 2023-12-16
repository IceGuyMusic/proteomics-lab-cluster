#!/bin/bash

# Define if its k3s kubectl or just kubectl
set_kubectl_command() {
    if command -v kubectl &> /dev/null; then
        KUBECTL_CMD="kubectl"
    elif command -v k3s &> /dev/null; then
        KUBECTL_CMD="k3s kubectl"
    else
        echo "kubectl or k3s is not installed. Please check this before running this command"
        exit 1
    fi
}

apply_manifest() {
    local manifest=$1
    echo "Apply Manifests: $manifest"
    $KUBECTL_CMD apply -f $manifest
    if [ $? -ne 0 ]; then
        echo "Error with Manifests: $manifest"
        exit 1
    fi
}

set_kubectl_command

BASE_DIR=$(pwd)

apply_manifest "$BASE_DIR/celeryworker/celeryworker-deployment.yaml"

apply_manifest "$BASE_DIR/jadzia/flaskapp-deployment.yaml"
apply_manifest "$BASE_DIR/jadzia/flaskapp-service.yaml"

apply_manifest "$BASE_DIR/jupyter-dir/jupyter-deployment.yaml"
apply_manifest "$BASE_DIR/jupyter-dir/jupyter-service.yaml"

apply_manifest "$BASE_DIR/pvc/flaskapp-claim0-persistentvolumeclaim.yaml"

apply_manifest "$BASE_DIR/redis/redis-deployment.yaml"
apply_manifest "$BASE_DIR/redis/redis-service.yaml"

echo "Applied all manifests"
