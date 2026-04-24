#!/bin/bash
set -euo pipefail

SIMULATOR_NAME="$(xcrun simctl list devices available | awk -F '[()]' '/iPhone/ {gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1); print $1; exit}')"

if [ -z "$SIMULATOR_NAME" ]; then
	echo "No available iPhone simulator found"
	exit 1
fi

xcodebuild test -project "Household Chore Rotation.xcodeproj" -scheme "Household Chore Rotation" -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" -only-testing:"Household Chore RotationTests"