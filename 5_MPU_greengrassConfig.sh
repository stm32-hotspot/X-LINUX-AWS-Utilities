#!/bin/bash

#******************************************************************************
# * @file           : 5_MPU_greengrassConfig.sh
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

systemctl stop greengrass

rm /opt/greengrass/v2/config/config.tlog*

sed -i "s/thingName: .*/thingName: \"${THING_NAME}\"/g" /opt/greengrass/v2/config/config.yaml
sed -i "s/privateKeyPath: .*/privateKeyPath: \"pkcs11:object=${PKCS11_KEY_LABEL};type=private\"/g" /opt/greengrass/v2/config/config.yaml
sed -i "s/certificateFilePath: .*/certificateFilePath: \"pkcs11:object=${PKCS11_KEY_LABEL};type=cert\"/g" /opt/greengrass/v2/config/config.yaml
sed -i "s/slot: .*/slot: \"${PKCS11_SLOT}\"/g" /opt/greengrass/v2/config/config.yaml
sed -i "s/userPin: .*/userPin: \"${PKCS11_USER_PIN}\"/g" /opt/greengrass/v2/config/config.yaml
sed -i "s/library: .*/library: \"${PKCS11_MODULE_LIB//\//\\/}\"/g" /opt/greengrass/v2/config/config.yaml
sed -i "s/awsRegion: .*/awsRegion: \"${REGION}\"/g" /opt/greengrass/v2/config/config.yaml
sed -i "s/iotCredEndpoint: .*/iotCredEndpoint: \"${CRED_ENDPOINT}\"/g" /opt/greengrass/v2/config/config.yaml
sed -i "s/iotDataEndpoint: .*/iotDataEndpoint: \"${DATA_ENDPOINT}\"/g" /opt/greengrass/v2/config/config.yaml
sed -i "s/iotRoleAlias: .*/iotRoleAlias: \"${ROLE_ALIAS_NAME}\"/g" /opt/greengrass/v2/config/config.yaml


systemctl start greengrass

echo "Greengrass configured and restarted."

script_name=$(basename "$0")
echo "$script_name script execution completed."