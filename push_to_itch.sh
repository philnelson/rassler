#!/bin/bash
TARGET_PREFIX = "youritchname"

butler push Bin/Release/rassler-windows64.zip philnelson/rassler:windows64
butler push Bin/Release/rassler-windows32.zip philnelson/rassler:windows32
butler push Bin/Release/rassler_macos.zip philnelson/rassler:macos
butler push Bin/rassler_linux.love philnelson/rassler:linux