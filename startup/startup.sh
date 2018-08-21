#!/bin/bash

NR_DXL=@opendxl/node-red-contrib-dxl
NR_PY2_ENV=node-red-py2-env

#
# Function that is invoked when the script fails.
#
# $1 - The message to display prior to exiting.
#
function fail() {
    echo $1
    echo "Exiting."
    exit 1
}

#
# Install OpenDXL extensions
#

cd /data \
    || { fail "Unable to switch to data directory"; }

if [ ! -f package.json ];then
    echo "Creating empty package.json..."
    echo "{}" > package.json \
        || { fail "Unable to create package.json."; }
fi

npm list --depth 1 ${NR_DXL} > /dev/null 2>&1
OUT=$?
if [ $OUT -ne 0 ];then
    echo "Installing ${NR_DXL}..."
    npm install ${NR_DXL} --save \
        || { fail "Unable to install ${NR_DXL}"; }
else
    echo "${NR_DXL} is already installed, skipping."
fi

if [ ! -f ${NR_PY2_ENV}/bin/activate ];then
    echo "Creating Python virtual environment..."
    python -m virtualenv ${NR_PY2_ENV} \
        || { fail "Unable to create Python virtual environment."; }
fi

source ${NR_PY2_ENV}/bin/activate     \
    || { fail "Unable to activate Python virtual environment."; }

cd /usr/src/node-red \
    || { fail "Unable to switch to node-red source directory"; }

# Start Node-RED
npm start -- --userDir /data

