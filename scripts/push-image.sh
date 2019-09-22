#!/bin/bash -e

function exit_with_usage {
    cat >&2 <<EOF

Usage:
    ./push-image.sh -i <image repository> -t <target> [-v <version>]
    ./push-image.sh --image <repository> --target <target> [--version <version>]
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

if [ "$target" != "build-target" -a "$target" != "archive-target" ] ; then
    echo "Invalid: --target" >&2
    exit_with_usage
fi

if [ "$target" = "build-target" ] ; then
    docker push "$image:build"
fi

if [ "$target" = "archive-target" ] ; then
    if [ ! "$version" ] ; then
        echo "Required: --version" >&2
        exit_with_usage
    fi

    docker push "$image:$version"
    docker push "$image:latest"
fi
