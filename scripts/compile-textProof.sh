#!/bin/bash

cd contracts/circuits

mkdir textProof

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling textProof.circom..."

# compile circuit

circom textProof.circom --r1cs --wasm --sym -o textProof
snarkjs r1cs info textProof/textProof.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup textProof/textProof.r1cs powersOfTau28_hez_final_10.ptau textProof/circuit_0000.zkey
snarkjs zkey contribute textProof/circuit_0000.zkey textProof/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey textProof/circuit_final.zkey textProof/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier textProof/circuit_final.zkey ../textProof.sol

cd ../..