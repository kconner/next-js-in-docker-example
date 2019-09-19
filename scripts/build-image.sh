#!/bin/bash -e

function exit_with_usage {
    cat >&2 <<EOF

Usage:
    ./build-image.sh -i <image repository> [-t <target>] [-v <version>] [-p]
    ./build-image.sh --image <repository> [--target <target>] [--version <version>] [--push]
EOF

    exit 1
}

target=archive-target

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
        --push|-p)
            push=true
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

docker pull "$image:build" || true

docker build \
    --target test-target \
    --cache-from "$image:build" \
    --tag "$image:test" \
    .

if [ "$target" != "test-target" ] ; then

    docker build \
        --target build-target \
        --cache-from "$image:build" \
        --tag "$image:build" \
        .

    if [ "$target" != "build-target" ] ; then

        docker pull "$image:latest" || true

        docker build \
            --target archive-target \
            --cache-from "$image:build" \
            --cache-from "$image:latest" \
            --tag "$image:$version" \
            --tag "$image:latest" \
            .

        if [ "$push" ] ; then
            docker push "$image:$version"
            docker push "$image:latest"
        fi

    fi

    if [ "$push" ] ; then
        docker push "$image:build"
    fi

fi
