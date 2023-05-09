# Initial Setup Guide

## Background 

This guide is written as a part of the proof of concept, written as a aprt of a bachelor project in Computer Science at NTNU Gjøvik, during the spring of 2023.

In order to use the system of OLM implemented proof of concept, a set of keys and certificates are necessary. This guide will go through the steps necessary, in order to start, run and use the applications.

## License Company Root Key Pair

The first step is to generate a key pair for the License Company, as the root.

This is done through:

1. Run the following command to create a private key and a certificate:
    ```bash
    openssl req -x509 -newkey rsa:4096 \
                -keyout rootkey.pem \
                -out rootcert.cert -sha256 \
                -days 3650
    ```
    Then follow the interactive guide presented. This creates a private key and a certificate. The certificate is self-signed, and is valid for 10 years.
2. Run the following command to generate a public key from the certificate:
    ```bash
    openssl x509 -in rootcert.cert \
                 -pubkey -noout > rootpub.pem
    ```
3. The private key (rootkey.pem) is kept in a secure place, the certificate (rootcert.cert) is distributed to the license file aggregator, and the public key (pubkey.pem) is distributed to the network management system. These are being used to cerify the origin of license signatures at a later time.
4. **Add part where root certificate is added to LFA in the correct place** 

## Network Management System Intermediate Key Pair

The next step is to generate an intermediate key pair for the Network Management System.

This is done through:

1. Run the following command to create a private key:
    ```bash
    openssl genrsa -aes256 -out nmskey.key 4096
    ```
2. Run the following command in order to create a certificate request:
    ```bash
    openssl req -new -sha256 \
                -key nmskey.key \
                -out nmscert.csr
    ```
    Then follow the interactive guide presented. This creates a private key and a certificate request.
3. Run the following command to sign the intermediate key with the root key:
    ```bash
    openssl ca  -extensions v3_intermediate_ca \
                -days 3650 -notext -md sha256 \
                -in nmscert.csr \
                -out nmscert.cert
    ``` 
    ***NOTE! I get error at this point: variable lookup failed for ca::default_ca***

    The intermediate key and intermediate certificate is to be distributed to the network management system.

4. **Add part where keystore is created, etc.**


## Application Startup

To start the application, the different parts are dependant on being started in the right order, in order to connect properly.

1. Start the Network Management System by following its guide.
    1. Initialize the files
    2. Start the jar
2. Start the License File Aggregator by following its guide.
    1. Enter correct name and port for the LFA, and the correct IP and port of the NMS.
    2. Build the project
    3. Run the application
    4. Enter the secret for the key
3. (Optional) Start the frontend
    1. Enter the correct IP and port of the NMS
    2. Build the project
    3. Run the application