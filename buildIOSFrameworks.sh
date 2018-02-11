#!/bin/sh
config="Release"
universalbuild -p ./Sodium.xcodeproj -s SodiumSwift -c    $config
universalbuild -p ./Sodium.xcodeproj -s SodiumCocoa -c    $config
