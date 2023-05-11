# License File Signer (LFS)

## Important
There is currently a private key located in this repository. By no means, whatsoever, should this be the case for anyone else. This is only here for simplicity sake so that people can clone and run the different projects wtihout any other necessary steps. 

## Background
The license file signer is developed and written as a part of a bachelor's thesis at the University of Science and Technology in Gjøvik, Norway.

## Description
LFS, short for license file signer, is the component acting as the licensing company in this proof of concept.

## Requirements
* OpenSSL ([windows](https://slproweb.com/products/Win32OpenSSL.html))

## Usage
To use the LFS correctly, clone the repository and set is at as the working directory. Then simply run the following command in the terminal:

For linux/macOS
```bash
./sign.sh <file_to_sign> <private_key_file>
```

where the `<file_to_sign>` is the *example_license.json* and the `<private_key_file>` is the *root-pk.key*

Finally, select the *example_licecnse.json* and *example_license.json.signature* and compress them to a zip file. The payload is now ready to be used.

The structure should be looking like this:

```
payload.zip/
├── license.json
└── license.json.signature
```

Alternatively, there is a already signed and ready payload located in the repository, named *example_payload.zip*.
