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
                -out rootcert.crt -sha256 \
                -days 3650
    ```
    Then follow the interactive guide presented. This creates a private key and a certificate. The certificate is self-signed, and is valid for 10 years.
2. Run the following command to generate a public key from the certificate:
    ```bash
    openssl x509 -in rootcert.crt \
                 -pubkey -noout > rootpub.pem
    ```
3. The private key (rootkey.pem) is kept in a secure place, the certificate (rootcert.crt) is distributed to the license file aggregator (follow steps below), and the public key (pubkey.pem) is distributed to the network management system (follow steps below). These are being used to cerify the origin of license signatures at a later time.
4. Update the NMS source code file named "CustomerConstants.java", and replace the current root public key with the updated one, with the exact format.

## Network Management System Intermediate Key Pair

The next step is to generate an intermediate key pair for the Network Management System.

This is done through:

1. Run the following command to create a private key:
    ```bash
    openssl genrsa -aes256 -out nmskey.pem 4096
    ```
2. Run the following command in order to create a certificate request:
    ```bash
    openssl req -new -sha256 \
                -key nmskey.pem \
                -out nmscert.csr
    ```
    Then follow the interactive guide presented. This creates a private key and a certificate request.
3. Run the following command to sign the intermediate key with the root key:
    ```bash
    openssl x509   -req \
                    -in nmscert.csr \
                    -CA rootcert.crt \
                    -CAkey rootkey.pem -CAcreateserial \
                    -out nmscert.crt -days 3600
    ``` 

    The intermediate key and intermediate certificate is to be distributed to the network management system.

4. Verify the intermediate certificate against the root certificate by running:
    ```bash
    openssl verify -CAfile rootcert.crt nmscert.crt
    ```
    Where the output should be `nmscert.crt: OK`.

5. Create a keystore object for the NMS software:
    1. Create a pkcs12 keystore with the intermediate cert and intermediate private key by running:
    ```bash
    openssl pkcs12  -export \
                -in nmscert.crt \
                -inkey nmskey.pem \
                -out keystore.p12 \
                -name keystore \
                -password pass:secret
    ```
    Please note that the password is `secret`, as stated in the source code. Do not use this in a production environment.
    2. Place the keystore in `src/main/resources/`.

## License File Aggregator Setup

1. Replace the root certificate, located in `cert/external/` with the newly created one, renamed to `root.cert`.

**Please note:** Do NOT alter the keys placed under `cert/internal/`. These are used for the web server HTTPS connection, and are not to be altered, unless new, signed, certificates are to be used.

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