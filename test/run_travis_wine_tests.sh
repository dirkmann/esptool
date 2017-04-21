#!/bin/bash
#
# Run some basic sanity tests using wine
# Designed to be run under Travis
#
PYTHON_DL_URL=$(printenv WINDOWS_PYTHON_${TRAVIS_PYTHON_VERSION}_DL)

[ -z $PYTHON_DL_URL ] && ( echo "Expected PYTHON_DL_URL to be set." && exit 1 )

mkdir wineroot
export WINEPREFIX="`pwd`/wineroot"
export WINEARCH=win32
unset DISPLAY

set -ex

wget --continue $PYTHON_DL_URL
PYTHON_INSTALL=$(basename $PYTHON_DL_URL)

# Windows Python installers are either MSI or WiX-based
# executable installers...
if [[ $(basename $PYTHON_DL_URL) == *.msi ]]; then
	wine msiexec /i $(PYTHON_INSTALL)
else
	xvfb-run wine ${PYTHON_INSTALL} /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
fi

wine pip install .
wine esptool.py --help
wine espsecure.py --help
wine espefuse.py --help

echo "esptool.py installed OK under Windows..."

