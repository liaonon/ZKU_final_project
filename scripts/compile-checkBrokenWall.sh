#!/bin/bash

cd contracts/circuits

mkdir checkBrokenWall

if [ -f ./powersOfTau28_hez_final_12.ptau ]; then
    echo "powersOfTau28_hez_final_12.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_12.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau
fi

echo "Compiling checkBrokenWall.circom..."

# compile circuit

circom checkBrokenWall.circom --r1cs --wasm --sym -o checkBrokenWall
snarkjs r1cs info checkBrokenWall/checkBrokenWall.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup checkBrokenWall/checkBrokenWall.r1cs powersOfTau28_hez_final_12.ptau checkBrokenWall/circuit_0000.zkey
snarkjs zkey contribute checkBrokenWall/circuit_0000.zkey checkBrokenWall/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey checkBrokenWall/circuit_final.zkey checkBrokenWall/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier checkBrokenWall/circuit_final.zkey ../checkBrokenWall.sol

cd ../..