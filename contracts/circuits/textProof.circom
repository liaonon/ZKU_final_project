
pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

template TextProof() {
    // Public inputs
    signal input textHash;
    signal input PublicHash;

    // Private inputs
    signal input privSalt;
    signal input senderAddress;

    // Output
    signal output out;

    // Verify that the hash of the private solution matches pubSolnHash
    component poseidon[3];

    for(var i=0; i<3; i++){   
        poseidon[i] = Poseidon(2);
    }

    poseidon[0].inputs[0] <== textHash;
    poseidon[0].inputs[1] <== privSalt;
    poseidon[1].inputs[0] <== privSalt;
    poseidon[1].inputs[1] <== senderAddress;
    poseidon[2].inputs[0] <== poseidon[0].out;
    poseidon[2].inputs[1] <== poseidon[1].out;

    component isEqual = IsEqual();
    isEqual.in[0] <== poseidon[2].out;
    isEqual.in[1] <== PublicHash;

    out <== isEqual.out;
 }

component main {public [textHash, PublicHash]} = TextProof();