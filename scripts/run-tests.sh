#!/bin/bash

if [ ! -f "test-place.rbxl" ]; then
	rojo build --output test-place.rbxl test.project.json
fi

set +e
run-in-roblox --place test-place.rbxl --script luau/run-package-tests.luau
status=$?
set -e

if [ -f "test-place.rbxl" ]; then
	rm -rf test-place.rbxl
fi

exit $status
