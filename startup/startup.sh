#!/bin/bash

NR_DXL=@opendxl/node-red-contrib-dxl@0.1.2
NR_CONFIG=node-red-contrib-config@1.1.2
NR_PY2_ENV=node-red-py2-env

DATA_DIR=/data
SETTINGS_FILE=$DATA_DIR/settings.js

CERTS_DIR=$DATA_DIR/certs
CERT_FILE=$CERTS_DIR/nr.crt
KEY_FILE=$CERTS_DIR/nr.key
CSR_FILE=$CERTS_DIR/nr.csr
CERT_DAYS=3650
REQUIRED_CA_FILES=($CERT_FILE $KEY_FILE)

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

cd $DATA_DIR \
    || { fail "Unable to switch to data directory"; }

# Copy settings file (if it does not exist)
if [ ! -f $SETTINGS_FILE ]; then
    echo "Copying settings file..."
    cp /startup/settings.js $SETTINGS_FILE  \
        || { fail 'Unable to copy Node-RED settings file.'; }
fi

#
# Check and possibly generate certificate information
#

if [ ! -d $CERTS_DIR ]; then
    echo "Creating certificates directory..."
    mkdir -p $CERTS_DIR || { fail 'Error creating certificates directory.'; }
fi

# Check to see if any of the required CA files exist
found_ca_file=false
for f in "${REQUIRED_CA_FILES[@]}"
do
    if [ -f $f ]; then
        found_ca_file=true
        break
	fi
done

if [ $found_ca_file = true ]
then
    # At least one file exists, make sure they all exist
    found_all_files=true
    for f in "${REQUIRED_CA_FILES[@]}"
    do
        if [ ! -f $f ]; then
            found_all_files=false
            echo "Required CA file not found: $f"
        fi
    done
    if [ $found_all_files = false ]; then
        fail 'Required CA files were not found.'
    fi
else
    # No CA files exist, generate them.
    echo "Generating certificate files..."

    # Create private key
    openssl genrsa -out $KEY_FILE 2048 \
        || { fail 'Error creating private key.'; }

    # Create certificate request
    openssl req -new -sha256 -key $KEY_FILE -out $CSR_FILE -subj "/CN=OpenDxlNodeRed" \
        || { fail 'Error creating certificate request.'; }

    # Sign certificate
    openssl x509 -req -in $CSR_FILE -signkey $KEY_FILE -out $CERT_FILE -days $CERT_DAYS \
        || { fail 'Error signing certificate request.'; }
fi

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

npm list --depth 1 ${NR_CONFIG} > /dev/null 2>&1
OUT=$?
if [ $OUT -ne 0 ];then
    echo "Installing ${NR_CONFIG}..."
    npm install ${NR_CONFIG} --save \
        || { fail "Unable to install ${NR_CONFIG}"; }
else
    echo "${NR_CONFIG} is already installed, skipping."
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
npm start -- --userDir $DATA_DIR
