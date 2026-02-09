#!/bin/bash

# Navigate to project root
cd "$(dirname "$0")/.."

echo "🧹 Starting Deep Clean for iOS..."

# 1. Kill Xcode to prevent locking files
killall Xcode || true

# 2. Clean Flutter artifacts
flutter clean

# 3. Clean iOS specific files
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/App.framework
rm -rf build/
rm -rf ios/DerivedData

# 4. Clean Xcode Derived Data (Global)
echo "🗑️  Cleaning Xcode Derived Data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 5. Re-install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

# 6. Install Pods with repo update
echo "🥥 Installing CocoaPods..."
cd ios
pod install --repo-update

echo "✅ Deep Clean Complete!"
echo "👉 Now open 'ios/Runner.xcworkspace' in Xcode and build."
