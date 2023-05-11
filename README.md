# License File Signer (LFS)

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

Alternatively, there is a already signed and ready payload located in the repository, named *example_payload.zip*.
