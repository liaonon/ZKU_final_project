#!/bin/bash

cd contracts/circuits

mkdir checkToken

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling checkToken.circom..."

# compile circuit

circom checkToken.circom --r1cs --wasm --sym -o checkToken
snarkjs r1cs info checkToken/checkToken.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup checkToken/checkToken.r1cs powersOfTau28_hez_final_10.ptau checkToken/circuit_0000.zkey
snarkjs zkey contribute checkToken/circuit_0000.zkey checkToken/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey checkToken/circuit_final.zkey checkToken/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier checkToken/circuit_final.zkey ../checkToken.sol

cd ../..