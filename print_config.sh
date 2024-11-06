#!/bin/bash

#******************************************************************************
# * @file           : print_config.sh
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

# Print variables to verify
echo "BOARD_IP                         : $BOARD_IP"
echo "REMOTE_SCRIPT_PATH               : $REMOTE_SCRIPT_PATH"
echo "THING_NAME                       : $THING_NAME"
echo "THING_GROUP_NAME                 : $THING_GROUP_NAME"
echo "AWS_IOT_POLICY                   : $AWS_IOT_POLICY"
echo "ROLE_ALIAS_NAME                  : $ROLE_ALIAS_NAME"
echo "EXCHANGE_ROLE_POLICY             : $EXCHANGE_ROLE_POLICY"
echo "ROLE_NAME                        : $ROLE_NAME"
echo "IOT_ROLE_ALIAS_POLICY_NAME       : $IOT_ROLE_ALIAS_POLICY_NAME"
echo "PKCS11_SLOT                      : $PKCS11_SLOT"
echo "PKCS11_TOKEN_LABEL               : $PKCS11_TOKEN_LABEL"
echo "PKCS11_SO_PIN                    : $PKCS11_SO_PIN"
echo "PKCS11_USER_PIN                  : $PKCS11_USER_PIN"
echo "PKCS11_KEY_LABEL                 : $PKCS11_KEY_LABEL"
echo "PKCS11_KEY_ID                    : $PKCS11_KEY_ID"
echo "PKCS11_MODULE_LIB                : $PKCS11_MODULE_LIB"
echo "OPENSSL_CONF_FILE                : $OPENSSL_CONF_FILE"
echo "CSR                              : $CSR"
echo "CSR_ON_PC                        : $CSR_ON_PC"
echo "CERT_ON_PC                       : $CERT_ON_PC"
echo "CERT                             : $CERT"
echo "REGION                           : $REGION"
echo "DATA_ENDPOINT                    : $DATA_ENDPOINT"
echo "CRED_ENDPOINT                    : $CRED_ENDPOINT"

echo "JSON_CONFIG_FILE                 : $JSON_CONFIG_FILE"
echo "IOT_POLICY_FILE                  : $IOT_POLICY_FILE"
echo "TOKEN_EXCHANGE_POLICY_FILE       : $TOKEN_EXCHANGE_POLICY_FILE"
echo "TOKEN_EXCHANGE_ACCESS_POLICY_FILE: $TOKEN_EXCHANGE_ACCESS_POLICY_FILE"
echo "CONFIG_FILE                      : $CONFIG_FILE"
echo "MPU_PKCS11_CONFIG_SCRIPT         : $MPU_PKCS11_CONFIG_SCRIPT"
echo "MPU_GG_CONFIG_SCRIPT             : $MPU_GG_CONFIG_SCRIPT"

echo "IOT_POLICY_DOCUMENT:"
echo $IOT_POLICY_DOCUMENT

echo "TOKEN_EXCHANGE_POLICY_DOCUMENT:"
echo $TOKEN_EXCHANGE_POLICY_DOCUMENT

echo "TOKEN_EXCHANGE_ACCESS_POLICY_DOCUMENT:"
echo $TOKEN_EXCHANGE_ACCESS_POLICY_DOCUMENT

echo "IOT_ROLE_ALIAS_POLICY_DOCUMENT:"
echo $IOT_ROLE_ALIAS_POLICY_DOCUMENT


