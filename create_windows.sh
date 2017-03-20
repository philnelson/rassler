#!/bin/bash
cd rassler.love
zip -r -9 rasslerzipped.love .
mv rasslerzipped.love ..
cd ..
cat Bin/love-0.10.2-win32/love.exe rasslerzipped.love > Rassler.exe