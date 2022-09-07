#!/bin/bash

# You shouldn't be building this here, you should be building this stuff as
#  part of your project, so this is just an example shell script and not a
#  formal makefile or whatever.

if [ ! -d "sdk" ]; then
    echo "This script expects the Steamworks SDK to be unpacked here." 1>&2
    echo "When unzipped, it makes an 'sdk' directory. Put that here." 1>&2
    exit 1
fi

set -e
set -x


#dylibbundler -b -x "q2probuilds/${ARCH}/${PLATFORM}/q2pro" -x "q2probuilds/${ARCH}/${PLATFORM}/q2proded" -d "q2probuilds/${ARCH}/lib" -of -p @executable_path/${ARCH}lib


OSTYPE=`uname -s`
if [ "$OSTYPE" = "Linux" ]; then
    g++ -Wl,-rpath='$ORIGIN' -o aqtion -Wall -O0 -ggdb3 steamshim_parent.cpp -I sdk/public sdk/redistributable_bin/linux64/libsteam_api.so -no-pie
    strip aqtion
    #gcc -o testapp -Wall -O0 -ggdb3 testapp.c steamshim_child.c
elif [ "$OSTYPE" = "Darwin" ]; then
    clang++ -o aqtion -Wall -O0 -ggdb3 -Dnullptr=0 steamshim_parent.cpp -I sdk/public sdk/redistributable_bin/osx/libsteam_api.dylib
    #clang -o testapp -Wall -O0 -ggdb3 testapp.c steamshim_child.c
else # mingw example here
    x86_64-w64-mingw32-g++ -Wall -O0 -ggdb3 steamshim_parent.cpp -I sdk/public sdk/redistributable_bin/win64/steam_api64.lib -c -o steamshim.o
    x86_64-w64-mingw32-g++ -static -static-libgcc -static-libstdc++ -o steamshim.exe steamshim.o -I sdk/public sdk/redistributable_bin/win64/steam_api64.lib
    exit 1
fi

set +e
set +x
echo ""
echo ""
echo ""
echo "HEY, PAY ATTENTION."
echo ""
echo "By default, this test app will RESET ALL YOUR ACHIEVEMENTS in Postal 1,"
echo " assuming you own that game on Steam. If you don't own that game on"
echo " Steam, this test app won't work. Please plan accordingly."
echo ""
echo ""
echo ""
echo 'You can run "steamshim" now, which will launch "testapp" by default and'
echo 'NUKE ALL YOUR ACHIEVEMENTS in Postal 1. Seriously, watch out.'
echo ""

exit 0

