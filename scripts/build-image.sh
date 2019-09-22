#!/bin/bash -e

function exit_with_usage {
    cat >&2 <<EOF

Usage:
    ./build-image.sh -i <image repository> -t <target> [-v <version>]
    ./build-image.sh --image <repository> --target <target> [--version <version>]
EOF

    exit 1
}

while [ "$#" -gt 0 ] ; do
    case "$1" in
        --image|-i)
            shift
            image="$1"
            ;;
        --target|-t)
            shift
            target="$1"
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

if [ "$target" != "test-target" -a "$target" != "build-target" -a "$target" != "archive-target" ] ; then
    echo "Invalid: --target" >&2
    exit_with_usage
fi

if [ "$target" = "archive-target" ] ; then
    if [ ! "$version" ] ; then
        echo "Required: --version" >&2
        exit_with_usage
    fi
fi

if [ "$target" = "test-target" ] ; then
    # Download the last build stage image, which may contain reusable layers
    docker pull "$image:build" || true

    # Build and tag the test stage image
    docker build \
        --target test-target \
        --cache-from "$image:build" \
        --tag "$image:test" \
        .
fi

if [ "$target" = "build-target" ] ; then
    # Build and tag the build stage image
    docker build \
        --target build-target \
        --cache-from "$image:test" \
        --cache-from "$image:build" \
        --tag "$image:build" \
        .
fi

if [ "$target" = "archive-target" ] ; then
    # Download the last archive stage image, which may contain reusable layers
    docker pull "$image:latest" || true

    # Build and tag the archive stage image
    docker build \
        --target archive-target \
        --cache-from "$image:build" \
        --cache-from "$image:latest" \
        --tag "$image:$version" \
        --tag "$image:latest" \
        .
fi
