pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";
include "../../node_modules/circomlib/circuits/switcher.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";

template CheckToken(n) {
    //public input
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; 
    signal input token;
    // privCHash is the hash in private text to certificate
    signal input privCHash;

    signal output out; 
    
    component poseidon[n];
    component switcher[n];

    var hashnumber = leaf;

    for(var i=0; i<n; i++){   
        switcher[i] = Switcher();
        switcher[i].sel <== path_index[i];
        switcher[i].L <== hashnumber;
        switcher[i].R <== path_elements[i];

        poseidon[i] = Poseidon(2);
        poseidon[i].inputs[0] <== switcher[i].outL;
        poseidon[i].inputs[1] <== switcher[i].outR;
        hashnumber = poseidon[i].out;
    }
    // Calculate the hash of root and token
    component rposeidon = Poseidon(2);
    rposeidon.inputs[0] <== hashnumber;
    rposeidon.inputs[1] <== token;

    // If is equal with token_check_hash
    component isEqual = IsEqual();
    isEqual.in[0] <== rposeidon.out;
    isEqual.in[1] <== privCHash;

    out <== isEqual.out;

}

component main = CheckToken(3);