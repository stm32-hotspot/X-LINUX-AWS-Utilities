#!/bin/bash

#******************************************************************************
# * @file           : 3_MPU_pkcs11Config.sh
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

# Source the configuration file
LOAD_CONFIG_FILE="./load_config.sh"
source $LOAD_CONFIG_FILE

# PKCS#11 Setup
pkcs11-tool --module ${PKCS11_MODULE_LIB} --init-token --slot ${PKCS11_SLOT} --label ${PKCS11_TOKEN_LABEL} --so-pin ${PKCS11_SO_PIN}

pkcs11-tool --module ${PKCS11_MODULE_LIB} --label ${PKCS11_TOKEN_LABEL} --slot ${PKCS11_SLOT} --login --so-pin ${PKCS11_SO_PIN} --init-pin --pin ${PKCS11_USER_PIN}

pkcs11-tool --module ${PKCS11_MODULE_LIB} -l --slot ${PKCS11_SLOT} --pin ${PKCS11_USER_PIN} --keypairgen --key-type rsa:2048 --label ${PKCS11_KEY_LABEL} --id ${PKCS11_KEY_ID} --usage-decrypt --usage-sign

echo ${PKCS11_USER_PIN} > /etc/pki/pin.txt

OPENSSL_CONF=${OPENSSL_CONF_FILE} openssl req -new -key "pkcs11:type=private;object=${PKCS11_KEY_LABEL};token=${PKCS11_TOKEN_LABEL}" -subj "/CN=${THING_NAME}" -out ${CSR}

script_name=$(basename "$0")
echo "$script_name script execution completed."