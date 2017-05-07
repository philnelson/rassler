#!/bin/bash

LOVE_FOLDER="rassler.love"
APP_NAME="Rassler.app"
LOVE_MACOS_ZIP="love-0.10.2-macosx-x64.zip"
DIST_NAME="rassler_macos.zip"

cd $LOVE_FOLDER
echo "Zipping .love folder"
zip -q -r -9 appzipped.love .
mv appzipped.love ../Bin
cd ../Bin

echo "Removing Old .app"
rm -rf Release/$APP_NAME
rm -rf Release/$DIST_NAME

echo "Copying New app"
cp -rf love.app $APP_NAME
mv appzipped.love $APP_NAME/Contents/Resources/SuperGame.love
mv $APP_NAME Release/
cd Release
echo "Zipping up the .app"
zip -q -r -9 $DIST_NAME $APP_NAME