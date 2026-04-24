#!/bin/bash

find "Household Chore Rotation" -name "*.swift" -print0 | xargs -0 swift-format lint --configuration .swift-format
