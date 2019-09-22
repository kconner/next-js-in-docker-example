#!/bin/bash -e

function exit_with_usage {
    cat >&2 <<EOF

Usage:
    ./run-internal-tests.sh -i <image repository>
    ./run-internal-tests.sh --image <repository>
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

# Run internal tests on a test image container
docker run \
    --rm \
    "$image:test" \
    npm run test:unit
