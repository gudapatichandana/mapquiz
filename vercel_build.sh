#!/bin/bash

# Fail on first error
set -e

echo "🚀 Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

echo "✅ Flutter version check"
flutter --version

echo "📦 Running flutter pub get"
flutter pub get

echo "🌐 Building Flutter web release"
flutter build web --release

echo "🎯 Build complete — output in build/web"
