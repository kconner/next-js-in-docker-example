#!/bin/bash -e

function exit_with_usage {
    cat >&2 <<EOF

Usage:
    ./run-external-tests.sh -i <image repository>
    ./run-external-tests.sh --image <repository>
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

server_name="server"

# Run the release web server on an archive image container
docker run \
    --name "$server_name" \
    --publish 3000:3000 \
    --detach \
    "$image:latest"

# Run external tests against the release web server,
# preserving the exit code
true # (Here you would run end-to-end tests against http://localhost:3000.)
result=$?

# Stop and discard the container
docker stop "$server_name"
docker rm "$server_name"

exit $result
