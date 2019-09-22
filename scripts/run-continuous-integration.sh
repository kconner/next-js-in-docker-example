#!/bin/bash -e

function exit_with_usage {
    cat >&2 <<EOF

Usage:
    ./run-continuous-integration.sh -i <image repository> -v <version>
    ./run-continuous-integration.sh --image <repository> --version <version>
EOF

    exit 1
}

while [ "$#" -gt 0 ] ; do
    case "$1" in
        --image|-i)
            shift
            image="$1"
            ;;
        --version|-v)
            shift
            version="$1"
            ;;
        *)
            echo "Unexpected: $1" >&2
            exit_with_usage
            ;;
    esac
    shift || true
done

if [ ! "$image" ] ; then
    echo "Required: --image" >&2
    exit_with_usage
fi

if [ ! "$version" ] ; then
    echo "Required: --version" >&2
    exit_with_usage
fi

echo '***' Build an image through the test stage 
./scripts/build-image.sh --image "$image" --target test-target

echo '***' Run internal tests in a test stage container 
./scripts/run-internal-tests.sh --image "$image"

echo '***' Build an image through the build stage 
./scripts/build-image.sh --image "$image" --target build-target

echo '***' Build an image through the archive stage 
./scripts/build-image.sh --image "$image" --target archive-target --version "$version"

echo '***' Run external tests against the release web server on an archive stage container 
./scripts/run-external-tests.sh --image "$image"

echo '***' Push the build stage image 
./scripts/push-image.sh --image "$image" --target build-target

# (Here you would quit early if running the workflow in an unmerged feature branch)

echo '***' Push the archive stage image 
./scripts/push-image.sh --image "$image" --target archive-target --version "$version"

echo '***' Deploy the archive stage to Kubernetes
./scripts/deploy-image.sh --image "$image" --version "$version"
