# X-LINUX-AWS-Utilities

## Description

X-LINUX-AWS-Utilities provides a set of scripts to configure the STM32MP135 DK as an AWS Greengrass Core device. These scripts automate the setup of AWS IoT resources, IAM roles, PKCS#11 secure key management, and the Greengrass service, ensuring secure communication with AWS IoT services. 

For additional support there is also a **[Tutorial Video](https://youtu.be/EeDcIzLYrH0?si=_d0WDGGocJBTb1GX)** that provides a detialed walkthrough of the steps provided below. 

## Prerequisites

- **[STM32MP1DK](https://www.st.com/en/evaluation-tools/stm32mp135f-dk.html)**: The device must be set up and [accessible over the network](https://wiki.st.com/stm32mpu/wiki/How_to_setup_a_WLAN_connection).
- **[X-LINUX-AWS](https://wiki.st.com/stm32mpu/wiki/X-LINUX-AWS_Starter_package)**: Ensure that X-LINUX-AWS is installed on the STM32MP1DK.
- [**Git Bash**](https://git-scm.com/downloads): Required for windows users as it provides a Unix-like shell that ensures compatibility with the Linux-style commands used in the scripts.
- **AWS Account**: Access to an AWS account with permissions to manage IAM, IoT, and Greengrass.
- [**AWS CLI**](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html): Ensure the AWS CLI is installed and [configured](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html) on your local machine.
- **SSH Access**: Ensure you can SSH into the STM32MP135 DK.

## Repository Structure

```
├── config.json
├── IoTPolicyDocument.json
├── IoTRoleAliasPolicy.json
├── TokenExchangeAccessPolicyDocument.json
├── TokenExchangeRoleAssumePolicyDocument.json
├── load_config.sh
├── print_config.sh
├── execute.sh
├── 1_PC_IamConfig.sh
├── 2_PC_IotConfig.sh
├── 3_MPU_pkcs11Config.sh
├── 4_PC_certConfig.sh
├── 5_MPU_greengrassConfig.sh
└── cleanup
    ├── IamConfig_Cleanup.sh
    └── IotConfig_Cleanup.sh
```

## Usage



### 1. Update Required Configuration Parameters
Before running the configuration scripts, you need to update specific fields in the `config.json` file to match your setup.

- **BOARD_IP**: The IP address of your STM32MP135 DK. Update this to match your device's network address.
  
- **THING_NAME**: A unique name for your IoT Thing. This name will be used in AWS IoT to identify your Greengrass Core device.

- **THING_GROUP_NAME**: The name of the IoT Thing Group you want to create for organizing your Greengrass Core devices. It helps in managing multiple devices efficiently.

> Note: There are optional configuration change described [below](#optional-configuration-parameters)


### 2. Run the Scripts

After making the necessary updates to `config.json`, run the following commands to load the configuration and execute the setup:

```bash
./execute.sh
```

### 3. Verifying Greengrass Core Functionality

There are two ways to check if the Greengrass Core is functioning properly:

- **Check in the AWS IoT Core Console**:
   - Log in to your AWS Management Console and navigate to the AWS IoT Core service. 
   - Your new greengrass core should populate under Manage > Greengrass devices > Core devices after a few minutes

- **Check the Greengrass Logs**:
   - You can also verify the connection by running the following command on your STM32MP135 DK:
     ```
     grep -r "Successfully connected to AWS IoT Core" /opt/greengrass/v2/logs
     ```
   - This command searches through the Greengrass logs for the specified message, indicating a successful connection to AWS IoT Core.


## Configuration Files

The configuration has been moved from a single script to several JSON files. These hold all the necessary variables for the scripts:

- **config.json**: Contains general configuration parameters (AWS region, IoT Thing and group names, etc.).
- **IoTPolicyDocument.json**: Defines the IoT policy document for the device.
- **IoTRoleAliasPolicy.json**: Defines Role alias policy. Updated by the *2_PC_IotConfig.sh* script
- **TokenExchangeAccessPolicyDocument.json**: Specifies the policy for Token Exchange access.
- **TokenExchangeRoleAssumePolicyDocument.json**: Defines the policy for Token Exchange role assumptions.

- **load_config.sh**: This script loads and parses the above JSON files and stores their contents as environment variables, ensuring that the other scripts can access these configurations.

- **print_config.sh**: This script prints the current configuration

### Optional Configuration Parameters

While the following parameters can be left as default, understanding them may help in future customization:

- **BoardConfiguration**:
  - **REMOTE_SCRIPT_PATH**: Path on the STM32MP135 DK where your scripts are located. Default is `"~/"`.

- **IoTConfiguration**:
  - **AWS_IOT_POLICY**: The IoT policy name for your Thing. Default is `"MyGreengrassV2IoTThingPolicy"`.
  - **ROLE_ALIAS_NAME**: The role alias for token exchange. Default is `"MyGreengrassCoreTokenExchangeRoleAlias"`.
  - **EXCHANGE_ROLE_POLICY**: Policy for Token Exchange access. Default is `"MyGreengrassV2TokenExchangeRoleAccess"`.
  - **ROLE_NAME**: Name of the IAM role for the Thing. Default is `"MyGreengrassV2TokenExchangeRole"`.
  - **IOT_ROLE_ALIAS_POLICY_NAME**: Policy name for the role alias. Default is `"MyGreengrassCoreTokenExchangeRoleAliasPolicy"`.
  - **REGION**: AWS region for the IoT resources. Updated by the *2_PC_IotConfig.sh* script
  - **DATA_ENDPOINT** : Endpoint address. Updated by the *2_PC_IotConfig.sh* script
  - **CRED_ENDPOINT** : Credential Endpoint address. Updated by the *2_PC_IotConfig.sh* script

- **PKCS11Configuration**:
  - **PKCS11_SLOT**: The slot number for the PKCS#11 token. Default is `"0"`.
  - **PKCS11_TOKEN_LABEL**: The label for the PKCS#11 token. Default is `"GG_token"`.
  - **PKCS11_SO_PIN**: Security Officer PIN for the token. Default is `"1234567890"`.
  - **PKCS11_USER_PIN**: User PIN for the token. Default is `"12345"`.
  - **PKCS11_KEY_LABEL**: Label for the key in the PKCS#11 token. Default is `"GG_key"`.
  - **PKCS11_KEY_ID**: ID for the key in the token. Default is `"0"`.
  - **PKCS11_MODULE_LIB**: Path to the PKCS#11 library. Default is `"/usr/lib/libckteec.so.0"`.
  - **OPENSSL_CONF_FILE**: Path to the OpenSSL configuration file. Default is `"/etc/pki/openssl-pkcs11-provider-optee.cnf"`.

- **CertificateConfiguration**:
  - **CSR**: Path for the Certificate Signing Request (CSR) on the STM32MP135 DK. Default is `"/tmp/mykey_csr.pem"`.
  - **CSR_ON_PC**: Path for the CSR on your local PC. Default is `"./mykey_csr.pem"`.
  - **CERT_ON_PC**: Path for the certificate on your PC. Default is `"./cert.pem"`.
  - **CERT**: Path for the certificate on the STM32MP135 DK. Default is `"/tmp/cert.pem"`.


## Script Summary

### load_config.sh

Parses the various configuration JSON files and exports their contents as environment variables. This script should be run before executing any of the others.

### 1_PC_IamConfig.sh

Sets up AWS IAM roles and policies for the device by:

- Loading the necessary configuration from the environment variables set by `load_config.sh`.
- Creates the IAM roles and policies required for Greengrass V2 setup.

### 2_PC_IotConfig.sh

Configures AWS IoT resources:

- Retrieves the AWS account ID for context.
- Creates an IoT Thing and Thing Group and attaches the Thing to the Group.
- Checks for and creates a Token Exchange Role Alias for secure role assumptions.

### 3_MPU_pkcs11Config.sh

Sets up PKCS#11 token for secure key management:

- Initializes the token, sets up user PINs, and generates RSA key pairs.
- Creates a Certificate Signing Request (CSR) associated with the IoT Thing.

### 4_PC_certConfig.sh

Handles certificate configuration:

- Transfers the CSR to the local machine, creates a certificate from it, and transfers it back to the device.
- Attaches the certificate to the IoT Thing and applies necessary policies.

### 5_MPU_greengrassConfig.sh

Configures and restarts the Greengrass Core service:

- Updates `config.yaml` with security settings and AWS resource details.

### execute.sh

Orchestrates the execution of all configuration scripts:

- Copies the local configuration to the STM32MP135 DK.
- Runs the IAM, IoT, PKCS#11, certificate, and Greengrass configuration scripts in sequence, with error checking at each step.

## Cleanup Scripts

After configuring the STM32MP135 DK as an AWS Greengrass Core device, you can use the provided cleanup scripts to remove the AWS resources created during the setup. These scripts will handle the deletion of IAM roles, IoT Things, certificates, policies, and other associated resources.

### IamConfig_Cleanup.sh

This script removes the IAM resources that were created during the configuration process:

- Deletes all inline policies attached to the specified IAM role.
- Deletes the IAM role itself if it exists.

Usage:
```bash
./cleanup/IamConfig_Cleanup.sh
```

### IotConfig_Cleanup.sh

This script removes the IoT and Greengrass resources:

- Deletes the IoT Role Alias.
- Detaches and deletes all policies attached to the IoT certificates.
- Deactivates, revokes, and deletes certificates associated with the IoT Thing.
- Deletes the IoT Thing and its associated Thing Group.
- Deletes the Greengrass Core device for the STM32MP135 DK.

Usage:
```bash
./cleanup/IotConfig_Cleanup.sh
```

> **Note**: Ensure that `config.json` has been updated with the desired configuration you would like to delete before executing these cleanup scripts.

By running these scripts, you can ensure a clean removal of resources created during the configuration of the STM32MP135 DK as a Greengrass Core device.


## Troubleshooting

If you encounter issues with the Greengrass Core or PKCS#11 operations, you can use the following commands to help diagnose and resolve the problems:

1. **View Greengrass Logs**:
   - To monitor the Greengrass logs in real-time, use the following command:
     ```
     tail -f /opt/greengrass/v2/logs/*
     ```
   - This command allows you to see the latest log entries and can help identify connectivity or service issues.

2. **Manage PKCS#11 Objects**:
   - If you need to delete specific PKCS#11 objects (such as certificates or keys), you can use the following commands:
     - To delete a certificate:
       ```
       pkcs11-tool --module ${PKCS11_MODULE_LIB} -l --slot ${PKCS11_SLOT} --pin ${PKCS11_USER_PIN} --id ${PKCS11_KEY_ID} --delete-object --type cert
       ```
     - To delete a private key:
       ```
       pkcs11-tool --module ${PKCS11_MODULE_LIB} -l --slot ${PKCS11_SLOT} --pin ${PKCS11_USER_PIN} --id ${PKCS11_KEY_ID} --delete-object --type privkey
       ```
     - To delete a public key:
       ```
       pkcs11-tool --module ${PKCS11_MODULE_LIB} -l --slot ${PKCS11_SLOT} --pin ${PKCS11_USER_PIN} --id ${PKCS11_KEY_ID} --delete-object --type pubkey
       ```
     - To list all objects in the specified slot:
       ```
       pkcs11-tool --module ${PKCS11_MODULE_LIB} --slot ${PKCS11_SLOT} --pin ${PKCS11_USER_PIN} --list-objects
       ```

> **Note**: Storing multiple keys in PKCS#11 can lead to connection and PKCS#11 issues, especially if `3_MPU_pkcs11Config.sh` is run multiple times. It's essential to manage your keys carefully to avoid conflicts that could disrupt connectivity.

These commands can assist you in diagnosing issues related to Greengrass connectivity and PKCS#11 key management. If problems persist, consider consulting AWS documentation or support for further assistance.
