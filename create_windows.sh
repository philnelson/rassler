#!/bin/bash
cd rassler.love
zip -r -9 rasslerzipped.love .
mv rasslerzipped.love ../Bin
cd ../Bin
cat love-0.10.2-win32/love.exe rasslerzipped.love > Rassler32.exe
cat love-0.10.2-win64/love.exe rasslerzipped.love > Rassler64.exe