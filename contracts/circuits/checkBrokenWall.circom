pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";

template checkWall(n) {
    //public input
    signal input pathWall[2];
    signal input gameHash;
    signal input brokenHash;
    
    // privCHash is the hash in private text to certificate
    signal input brokenWall[n][2];
    signal input wallsA[n][2];
    signal input wallsB[n][2];
    signal input saltA;
    signal input saltB;

    signal output out; 

    // check pathWall (x, y) is less than 10
    component lessThan[2];
    for(var i=0; i<2; i++){
        lessThan[i] = LessThan(4);
        lessThan[i].in[0] <== pathWall[i];
        lessThan[i].in[1] <== 10;
        1 === lessThan[i].out;
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

    // check brokenWall hash is equal or not
    component brokenWallHash = Poseidon(n+1);
    for(var i=0; i<n; i++){
        brokenWallHash.inputs[i] <== xbrokenWall[i];
    }
    brokenWallHash.inputs[n] <== gameHash;
    brokenHash === brokenWallHash.out;

    // Convert the coordinates of the pathwall to two digits
    var xpathWall = pathWall[0]*10 +pathWall[1];

    // check if the wall in brokenWall or not
    component isEqual[n];
    var outNumber = 0;
    for(var i=0; i<n; i++){
        isEqual[i] = IsEqual();
        isEqual[i].in[0] <== xbrokenWall[i];
        isEqual[i].in[1] <== xpathWall;
        outNumber = outNumber + isEqual[i].out;
    }

    out <== outNumber;

}

component main {public [pathWall, gameHash]} = checkWall(6);