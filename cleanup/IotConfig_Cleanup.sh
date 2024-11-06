#!/bin/bash

#******************************************************************************
# * @file           : IotConfig_Cleanup.sh
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

# set -e  # Exit immediately if a command exits with a non-zero status

# Source the configuration file
CONFIG_FILE="./load_config.sh"
source $CONFIG_FILE

# List all principals (certificates) attached to the Thing
PRINCIPALS=$(aws iot list-thing-principals --thing-name "${THING_NAME}" --output text --query 'principals')


if [ -z "$PRINCIPALS" ]; then
    echo "No principals (certificates) attached to the Thing '${THING_NAME}'."
else
    # Loop through each principal (certificate)
    for CERT_ARN in $PRINCIPALS; do
        echo "Processing certificate: ${CERT_ARN}"

        # List and delete all policies attached to the certificate
        POLICIES=$(aws iot list-attached-policies --target "${CERT_ARN}" --output text --query 'policies' | sort | uniq)

        for POLICY_ARN in $POLICIES; do
            POLICY_NAME=$(basename "${POLICY_ARN}")
            echo "Detaching policy: ${POLICY_NAME} from certificate: ${CERT_ARN}"
            aws iot detach-policy --policy-name "${POLICY_NAME}" --target "${CERT_ARN}"

            # Check if the policy exists before trying to delete it
            if aws iot get-policy --policy-name "${POLICY_NAME}" > /dev/null 2>&1; then
                echo "Deleting policy: ${POLICY_NAME}"
                aws iot delete-policy --policy-name "${POLICY_NAME}"
            else
                echo "Policy ${POLICY_NAME} does not exist, skipping deletion."
            fi
        done

        # Extract the certificate ID from the ARN
        CERT_ID=$(basename "${CERT_ARN}")

        # Detach the certificate from the Thing
        echo "Detaching certificate from Thing: ${THING_NAME}"
        aws iot detach-thing-principal --thing-name "${THING_NAME}" --principal "${CERT_ARN}"

        # Attempt to deactivate the certificate
        echo "Deactivating certificate: ${CERT_ARN}"
        aws iot update-certificate --certificate-id "${CERT_ID}" --new-status INACTIVE || echo "Warning failed to deactivate certificate: ${CERT_ARN}"

        # Attempt to revoke the certificate
        echo "Revoking certificate: ${CERT_ARN}"
        aws iot update-certificate --certificate-id "${CERT_ID}" --new-status REVOKED || echo "Warning failed to revoke certificate: ${CERT_ARN}"

        # Delete the certificate
        echo "Deleting certificate: ${CERT_ARN}"
        aws iot delete-certificate --certificate-id "${CERT_ID}" || echo "Warning failed to delete certificate: ${CERT_ARN}"
    done
fi

# Delete the IoT Thing
echo "Deleting IoT Thing: ${THING_NAME}"
aws iot delete-thing --thing-name "${THING_NAME}"


echo "Deleting Thing Group '$THING_GROUP_NAME'"
aws iot delete-thing-group --thing-group-name "$THING_GROUP_NAME"
echo "Deleted Thing Group: $THING_GROUP_NAME"

echo "Deleting GreenGrass core V2 '$THING_NAME'"
aws greengrassv2 delete-core-device --core-device-thing-name ${THING_NAME}
echo "Deleted GreenGrass core V2 '$THING_NAME'"

echo "Cleanup completed for IoT Thing: ${THING_NAME}"
