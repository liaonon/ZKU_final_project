pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";

template checkWall(n) {
    //public input
    
    signal input gameHash;
    
    // privCHash is the hash in private text to certificate
    signal input brokenWall[n][2];

    signal input wallsA[n][2];
    signal input wallsB[n][2];
    signal input saltA;
    signal input saltB;

    signal output out; 

    // check brokenWall (x, y) is less than 10
    component lessThan[2*n];
    for(var i=0; i<n; i++){
        lessThan[i] = LessThan(4);
        lessThan[i].in[0] <== brokenWall[i][0];
        lessThan[i].in[1] <== 10;
        1 === lessThan[i].out;

        lessThan[i+n] = LessThan(4);
        lessThan[i+n].in[0] <== brokenWall[i][1];
        lessThan[i+n].in[1] <== 10;
        1 === lessThan[i+n].out;
    }

    // check game hash is equal or not
    var xwallsA[n];
    for(var i=0; i<n; i++){
        xwallsA[i] = wallsA[i][0]*10 + wallsA[i][1]; 
    }
    var xwallsB[n];
    for(var i=0; i<n; i++){
        xwallsB[i] = wallsB[i][0]*10 + wallsB[i][1]; 
    }
    component poseidon[3];
    poseidon[0] = Poseidon(n);
    poseidon[1] = Poseidon(n);
    poseidon[2] = Poseidon(4);
    for(var i=0; i<n; i++){
        poseidon[0].inputs[i] <== xwallsA[i];
    }
    for(var i=0; i<n; i++){
        poseidon[1].inputs[i] <== xwallsB[i];
    }
    poseidon[2].inputs[0] <== poseidon[0].out;
    poseidon[2].inputs[1] <== poseidon[1].out;
    poseidon[2].inputs[2] <== saltA;
    poseidon[2].inputs[3] <== saltB;

    gameHash === poseidon[2].out;
    
    // Convert the coordinates of the pathwall to two digits
    var xbrokenWall[n];
    for(var i=0; i<n; i++){
        xbrokenWall[i] = brokenWall[i][0]*10 + brokenWall[i][1]; 
    }

    //Calculate hash with broken wall
    component brokenWallHash = Poseidon(n+1);
    for(var i=0; i<n; i++){
        brokenWallHash.inputs[i] <== xbrokenWall[i];
    }
    brokenWallHash.inputs[n] <== gameHash;

    out <== brokenWallHash.out;

}

component main {public [gameHash]} = checkWall(2);