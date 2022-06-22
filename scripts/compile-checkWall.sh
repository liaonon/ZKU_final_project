#!/bin/bash

cd contracts/circuits

mkdir checkWall

if [ -f ./powersOfTau28_hez_final_12.ptau ]; then
    echo "powersOfTau28_hez_final_12.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_12.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau
fi

echo "Compiling checkWall.circom..."

# compile circuit

circom checkWall.circom --r1cs --wasm --sym -o checkWall
snarkjs r1cs info checkWall/checkWall.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup checkWall/checkWall.r1cs powersOfTau28_hez_final_12.ptau checkWall/circuit_0000.zkey
snarkjs zkey contribute checkWall/circuit_0000.zkey checkWall/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey checkWall/circuit_final.zkey checkWall/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier checkWall/circuit_final.zkey ../checkWall.sol

cd ../..