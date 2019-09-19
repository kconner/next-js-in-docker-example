#!/bin/bash -e

function exit_with_usage {
    cat >&2 <<EOF

Usage:
    ./test-image.sh -i <image repository>
    ./test-image.sh --image <repository>
EOF

    exit 1
}

while [ "$#" -gt 0 ] ; do
    case "$1" in
        --image|-i)
            shift
            image="$1"
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

docker run \
    --rm \
    "$image:test" \
    npm run test:unit
