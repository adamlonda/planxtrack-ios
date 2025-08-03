#!/bin/bash

# Retrieve current Xcode version and build number
xcode_version=$(xcodebuild -version | awk 'NR==1 {print $2}')
xcode_build=$(xcodebuild -version | awk 'NR==2 {print $3}')

# Update the README.md file
sed -i '' "s/Xcode [0-9.]* ([0-9A-Z]*)/Xcode $xcode_version ($xcode_build)/" README.md

echo "README.md updated with Xcode $xcode_version ($xcode_build)"