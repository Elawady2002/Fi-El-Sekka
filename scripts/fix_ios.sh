#!/bin/bash

# Navigate to project root
cd "$(dirname "$0")/.."

echo "🚀 Starting iOS Fix & Clean..."

# 1. Clean Flutter build artifacts
flutter clean

# 2. Cleanup iOS specific files
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf build/

# 3. Get Flutter dependencies
flutter pub get

# 4. Re-install Pods
cd ios
pod install --repo-update

echo "✅ iOS Build Environment Repaired!"
echo "You can now try building from Xcode or running 'flutter build ios'."
