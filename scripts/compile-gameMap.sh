#!/bin/bash

cd contracts/circuits

mkdir gameMap

if [ -f ./powersOfTau28_hez_final_12.ptau ]; then
    echo "powersOfTau28_hez_final_12.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_12.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau
fi

echo "Compiling gameMap.circom..."

# compile circuit

circom gameMap.circom --r1cs --wasm --sym -o gameMap
snarkjs r1cs info gameMap/gameMap.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup gameMap/gameMap.r1cs powersOfTau28_hez_final_12.ptau gameMap/circuit_0000.zkey
snarkjs zkey contribute gameMap/circuit_0000.zkey gameMap/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey gameMap/circuit_final.zkey gameMap/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier gameMap/circuit_final.zkey ../gameMap.sol

cd ../..