#!/bin/bash
cd rassler.love
echo "Zipping .love folder"
zip -q -r -9 rasslerzipped.love .
mv rasslerzipped.love ../Bin
cd ../Bin

echo "Removing Old Rassler zips"
cd Release
rm rassler-windows32.zip
rm rassler-windows64.zip
cd ..

echo "Unzipping fresh 32-bit windows build"
unzip -q love-0.10.2-win32.zip
cd love-0.10.2-win32
echo "Creating 32-bit rassler.exe"
cat love.exe ../rasslerzipped.love > Rassler.exe
echo "Removing 32-bit love.exe"
rm love.exe
cd ..
echo "Zipping up windows 32"
zip -q -r -9 rassler-windows32.zip love-0.10.2-win32
mv rassler-windows32.zip Release/
rm -rf love-0.10.2-win32

echo "Unzipping fresh 64-bit windows build"
unzip -q love-0.10.2-win64.zip
cd love-0.10.2-win64
echo "Creating 64-bit rassler.exe"
cat love.exe ../rasslerzipped.love > Rassler.exe
echo "Removing 64-bit love.exe"
rm love.exe
cd ..
echo "Zipping up windows 64"
zip -q -r -9 rassler-windows64.zip love-0.10.2-win64
mv rassler-windows64.zip Release/
rm -rf love-0.10.2-win64

rm -rf rasslerzipped.love