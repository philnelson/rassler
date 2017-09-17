#!/bin/bash
cd rassler.love
echo "Zipping .love folder"
zip -q -r -9 rassler_linux.love .
mv rassler_linux.love ../Bin