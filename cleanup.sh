#!/bin/bash

#******************************************************************************
# * @file           : cleanup.sh
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

# Function to delete a file from the board
delete_file_from_board() {
    local FILE_TO_DELETE="$1"
    REMOTE_FILE_PATH=${REMOTE_SCRIPT_PATH}${FILE_TO_DELETE}
    echo "Deleting $FILE_TO_DELETE from to the board..."
    ssh root@$BOARD_IP "rm $REMOTE_FILE_PATH"
}

LOAD_CONFIG_FILE="./load_config.sh"
source $LOAD_CONFIG_FILE

source cleanup/IotConfig_Cleanup.sh
source cleanup/IamConfig_Cleanup.sh

echo "Cleaning up board"
ssh root@$BOARD_IP "pkcs11-tool --module ${PKCS11_MODULE_LIB} -l --slot ${PKCS11_SLOT} --pin ${PKCS11_USER_PIN}  --id ${PKCS11_KEY_ID}  --delete-object --type cert"
ssh root@$BOARD_IP "pkcs11-tool --module ${PKCS11_MODULE_LIB} -l --slot ${PKCS11_SLOT} --pin ${PKCS11_USER_PIN}  --id ${PKCS11_KEY_ID}  --delete-object --type privkey"
ssh root@$BOARD_IP "pkcs11-tool --module ${PKCS11_MODULE_LIB} -l --slot ${PKCS11_SLOT} --pin ${PKCS11_USER_PIN}  --id ${PKCS11_KEY_ID}  --delete-object --type pubkey"

# Delete the configuration files from the board
delete_file_from_board $LOAD_CONFIG_FILE
delete_file_from_board $PRINT_CONFIG_FILE
delete_file_from_board $JSON_CONFIG_FILE
delete_file_from_board $MPU_PKCS11_CONFIG_SCRIPT
delete_file_from_board $MPU_GG_CONFIG_SCRIPT

script_name=$(basename "$0")
echo "$script_name script execution completed."
