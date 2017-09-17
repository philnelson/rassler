#!/bin/bash
TARGET_PREFIX="youritchname"

butler push Bin/Release/rassler-windows64.zip $TARGET_PREFIX/rassler:windows64
butler push Bin/Release/rassler-windows32.zip $TARGET_PREFIX/rassler:windows32
butler push Bin/Release/rassler_macos.zip $TARGET_PREFIX/rassler:macos
butler push Bin/rassler_linux.love $TARGET_PREFIX/rassler:linux