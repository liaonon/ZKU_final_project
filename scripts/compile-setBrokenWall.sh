#!/bin/bash

cd contracts/circuits

mkdir setBrokenWall

if [ -f ./powersOfTau28_hez_final_12.ptau ]; then
    echo "powersOfTau28_hez_final_12.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_12.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau
fi

echo "Compiling setBrokenWall.circom..."

# compile circuit

circom setBrokenWall.circom --r1cs --wasm --sym -o setBrokenWall
snarkjs r1cs info setBrokenWall/setBrokenWall.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup setBrokenWall/setBrokenWall.r1cs powersOfTau28_hez_final_12.ptau setBrokenWall/circuit_0000.zkey
snarkjs zkey contribute setBrokenWall/circuit_0000.zkey setBrokenWall/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey setBrokenWall/circuit_final.zkey setBrokenWall/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier setBrokenWall/circuit_final.zkey ../setBrokenWall.sol

cd ../..