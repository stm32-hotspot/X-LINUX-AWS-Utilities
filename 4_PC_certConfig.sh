#!/bin/bash

#******************************************************************************
# * @file           : 4_PC_certConfig.sh
# * @brief          : 
# ******************************************************************************
# * @attention
# *
# * <h2><center>&copy; Copyright (c) 2022 STMicroelectronics.
# * All rights reserved.</center></h2>
# *
# * This software component is licensed by ST under BSD 3-Clause license,
# * the "License"; You may not use this file except in compliance with the
# * License. You may obtain a copy of the License at:
# *                        opensource.org/licenses/BSD-3-Clause
# ******************************************************************************

set -e  # Exit immediately if a command exits with a non-zero status

# Source the configuration file
LOAD_CONFIG_FILE="load_config.sh"
source $LOAD_CONFIG_FILE

# Copy CSR from board to local machine
echo "Copying CSR from board to local machine..."
scp root@${BOARD_IP}:${CSR} ${CSR_ON_PC}
if [ $? -ne 0 ]; then
    echo "Failed to copy CSR from board to local machine."
    exit 1
fi

# Create certificate from CSR
echo "Creating certificate from CSR..."
CERT_ARN=$(aws iot create-certificate-from-csr --certificate-signing-request file://${CSR_ON_PC} --certificate-pem-outfile ${CERT_ON_PC} --set-as-active --output text --query 'certificateArn')
if [ $? -ne 0 ]; then
    echo "Failed to create certificate from CSR."
    exit 1
fi
echo "Certificate ARN: ${CERT_ARN}"

# Copy certificate to board
echo "Copying certificate to board..."
scp ${CERT_ON_PC} root@${BOARD_IP}:${CERT}
if [ $? -ne 0 ]; then
    echo "Failed to copy certificate to board."
    exit 1
fi

# Attach certificate to IoT Thing
echo "Attaching certificate to IoT Thing..."
aws iot attach-thing-principal --thing-name ${THING_NAME} --principal ${CERT_ARN}
if [ $? -ne 0 ]; then
    echo "Failed to attach certificate to IoT Thing."
    exit 1
fi

# Attach policy to certificate
echo "Attaching IoT policy to certificate..."
aws iot attach-policy --policy-name ${AWS_IOT_POLICY} --target ${CERT_ARN}
if [ $? -ne 0 ]; then
    echo "Failed to attach policy to certificate."
    exit 1
fi

# Attach policy to certificate
echo "Attaching role alias policy to certificate..."
aws iot attach-policy --policy-name ${IOT_ROLE_ALIAS_POLICY_NAME} --target ${CERT_ARN}
if [ $? -ne 0 ]; then
    echo "Failed to attach policy to certificate."
    exit 1
fi

# Run pkcs11-tool command on the board
echo "Running pkcs11-tool on the board..."
ssh root@${BOARD_IP} "pkcs11-tool --module ${PKCS11_MODULE_LIB} --slot ${PKCS11_SLOT} --pin ${PKCS11_USER_PIN} --write-object ${CERT} --type cert --label ${PKCS11_KEY_LABEL} --id ${PKCS11_KEY_ID}"
if [ $? -ne 0 ]; then
    echo "Failed to run pkcs11-tool on the board."
    exit 1
fi

script_name=$(basename "$0")
echo "$script_name script execution completed."
