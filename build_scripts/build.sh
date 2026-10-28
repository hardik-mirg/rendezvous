#!/bin/bash

# Build script for Rendezvous
# Usage: ./build.sh -p [macos|android|web]
# Platform options:
#   - macos: Builds for macOS using Swift
#   - android: Builds for Android using Kotlin/Java
#   - web: Builds for web using Rust and WebAssembly

# Exit on error
set -e

# Parse command line arguments
while getopts "p:" opt; do
  case $opt in
    p)
      PLATFORM="$OPTARG"
      ;;
    \?)
      echo "Usage: $0 -p [macos|android|web]"
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

# Validate platform
if [ -z "$PLATFORM" ]; then
  echo "Error: Platform argument is required."
  exit 1
fi

# Build for macOS
if [ "$PLATFORM" = "macos" ]; then
  echo "Building for macOS...
  cd src
  swift build -c release
  cd ..
  echo "Build completed for macOS."
fi

# Build for Android
if [ "$PLATFORM" = "android" ]; then
  echo "Building for Android...
  cd src/android
  ./gradlew assembleRelease
  cd ../..
  echo "Build completed for Android."
fi

# Build for Web
if [ "$PLATFORM" = "web" ]; then
  echo "Building for Web...
  cd src/web
  wasm-pack build --target web
  cd ../..
  echo "Build completed for Web."
fi

# Summary
echo "Build process completed for platform: $PLATFORM"

# Note: Ensure you have the necessary dependencies installed for each platform
# macOS: Swift installed
# Android: Kotlin/Java environment and Gradle
# Web: Rust and wasm-pack installed

# Example: Run with
# ./build.sh -p macos
# ./build.sh -p android
# ./build.sh -p web