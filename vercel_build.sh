#!/bin/bash
set -e

echo "🚀 Setting up Flutter for Vercel build..."

# Download Flutter SDK (only stable channel, shallow clone for speed)
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Check Flutter version
flutter --version

# Get project dependencies
flutter pub get

# Build the web release
flutter build web --release

echo "✅ Flutter web build complete — output in build/web"
