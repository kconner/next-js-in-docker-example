#!/bin/bash -e

function exit_with_usage {
    cat >&2 <<EOF

Usage:
    ./deploy-image.sh -i <image repository> -v <version> [-d]
    ./deploy-image.sh --image <repository> --version <version> [--delete]
EOF

    exit 1
}

while [ "$#" -gt 0 ] ; do
    case "$1" in
        --image|-i)
            shift
            export IMAGE="$1"
            ;;
        --version|-v)
            shift
            export VERSION="$1"
            ;;
        --delete|-d)
            delete=true
            ;;
        *)
            echo "Unexpected: $1" >&2
            exit_with_usage
            ;;
    esac
    shift || true
done

if [ ! "$IMAGE" ] ; then
    echo "Required: --image" >&2
    exit_with_usage
fi

if [ ! "$VERSION" ] ; then
    echo "Required: --version" >&2
    exit_with_usage
fi

mkdir -p /tmp/manifests
deployment_path=/tmp/manifests/deployment.yml
service_path=/tmp/manifests/service.yml

# Fill in values of IMAGE and VERSION using templates.
eval echo "\"$(< manifests/deployment-template.yml)\"" > $deployment_path
eval echo "\"$(< manifests/service-template.yml)\"" > $service_path

if [ "$delete" ] ; then
    command="delete"
else
    command="apply"
fi

kubectl "$command" -f "$deployment_path" -f "$service_path"
