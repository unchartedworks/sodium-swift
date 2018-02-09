#!/bin/sh
universalbuild -p ./Sodium.xcodeproj -s SodiumSwift -c Debug
universalbuild -p ./Sodium.xcodeproj -s SwiftCommon -c Debug
universalbuild -p ./Sodium.xcodeproj -s SwiftCommonIOS -c Debug
