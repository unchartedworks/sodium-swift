#!/bin/sh
config="Release"
universalbuild -p ./Sodium.xcodeproj -s SodiumSwift-macOS -c $config
universalbuild -p ./Sodium.xcodeproj -s SwiftCommon-macOS -c $config
