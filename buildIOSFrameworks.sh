#!/bin/sh
config="Debug"
universalbuild -p ./Sodium.xcodeproj -s SodiumSwift -c    $config
universalbuild -p ./Sodium.xcodeproj -s SwiftCommon -c    $config
universalbuild -p ./Sodium.xcodeproj -s SwiftCommonIOS -c $config
universalbuild -p ./Sodium.xcodeproj -s SodiumCocoa -c    $config
