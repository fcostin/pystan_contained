#! /bin/bash

# PURPOSE:
#
# run python3 scripts that depend upon pystan inside a
# docker container to isolate and contain pystan dependencies
# from the host environment.
#
# USAGE:
#
# Ensure the docker daemon is running.
#
# Ensure your working directory contains:
# - this script
# - a directory named src/
# - a directory named httpstan_cache/
#
# The src directory will be bind-mounted into the
# container for filesystem input and build output.
#
# ./pystanenv.sh python3 yourscript.py
#
# where yourscript.py lives inside src/
#
# The httpstan_cache directory will be bind-mounted
# into the container at the location that httpstan
# uses to cache compiled models. This allows the cache
# to be shared between ephemeral pystanenv container
# lifetimes.

set -euo pipefail

# Ensure container image is built
docker build -t pystanenv:dev -f pystan.3.9.7.Dockerfile .

# must align with httpstan.cache.cache_directory()
STAN_USER_CACHE_DIR=/home/stanuser/.cache/httpstan/4.6.0

ENTRYPOINT=$1

shift 1 # pop $1 from $@; we defer tail of $@ to entrypoint

docker run --rm \
  --name pystanenv \
  --workdir /work \
  --mount type=bind,source="$(pwd)"/httpstan_cache,target="$STAN_USER_CACHE_DIR" \
  --mount type=bind,source="$(pwd)"/src,target=/work/src \
  --entrypoint "$ENTRYPOINT" \
  pystanenv:dev \
  $@

