#!/usr/bin/env bash
#
# Build redo-lightfm and run the full test suite inside the manylinux x86_64
# image, for a single Python version.
#
# Run from the repository root:
#
#   ./test-scripts/verify.sh 311
#   ./test-scripts/verify.sh 312
#   ./test-scripts/verify.sh 313
#
# The repo is mounted read-only and copied to /build inside the container, so
# nothing is written to the working tree.

set -euo pipefail

PYVER="${1:?usage: ./test-scripts/verify.sh <311|312|313>}"
IMAGE="quay.io/pypa/manylinux_2_28_x86_64"
MARCH="x86-64"

podman run --rm --platform linux/amd64 \
  -v "$PWD":/src:ro \
  -e PYVER="$PYVER" \
  -e LIGHTFM_MARCH="$MARCH" \
  "$IMAGE" \
  bash -euxo pipefail -c '
    PY="/opt/python/cp${PYVER}-cp${PYVER}/bin/python"

    cp -r /src /build
    cd /build
    rm -rf build ./*.egg-info

    "$PY" -m pip install --quiet numpy scipy requests scikit-learn pytest
    "$PY" -m pip install .

    # Drop the source package so the tests import the installed extension.
    rm -rf /build/redo_lightfm

    cd /tmp
    "$PY" -c "import redo_lightfm; print(redo_lightfm.__file__)"
    "$PY" -m pytest /build/tests
  '
