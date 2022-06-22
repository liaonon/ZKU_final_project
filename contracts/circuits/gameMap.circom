
pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

template gameMap(n) {

    // Public inputs
    signal input wallsA[n][2];
    signal input wallsB[n][2];

    // Private inputs
    signal input saltA;
    signal input saltB;

    // Output
    signal output out;

    // Verify that the input walls (x, y) all less equal than 10

    component checkwallsA[2*n];
    component checkwallsB[2*n];

    // Check playerA's input
    for(var i=0; i<n; i++){
        checkwallsA[i] = LessThan(4);
        checkwallsA[i].in[0] <== wallsA[i][0];
        checkwallsA[i].in[1] <== 10;
        1 === checkwallsA[i].out;

        checkwallsA[i+n] = LessThan(4);
        checkwallsA[i+n].in[0] <== wallsA[i][1];
        checkwallsA[i+n].in[1] <== 10;
        1 === checkwallsA[i+n].out;
    }

    // Check playerB's input
    for(var i=0; i<n; i++){
        checkwallsB[i] = LessThan(4);
        checkwallsB[i].in[0] <== wallsB[i][0];
        checkwallsB[i].in[1] <== 10;
        1 === checkwallsB[i].out;

        checkwallsB[i+n] = LessThan(4);
        checkwallsB[i+n].in[0] <== wallsB[i][1];
        checkwallsB[i+n].in[1] <== 10;
        1 === checkwallsB[i+n].out;
    }
    // Convert the coordinate value of the wall to two digits
    // which is convenient for calculating the hash value.
    
    // The walls numbers as follow:
    //   21  41  61  81
    // 12  32  52  72  92
    //   23  43  63  83
    // 14  34  54  74  94
    //   25  45  65  85
    // 16  36  56  76  96
    //   27  47  67  87
    // 18  38  58  78  98
    //   29  49  69  89

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

    // Ues poseidon to get palyerA's map hash
    for(var i=0; i<n; i++){
        poseidon[0].inputs[i] <== xwallsA[i];
    }

    // Ues poseidon to get palyerB's map hash
    for(var i=0; i<n; i++){
        poseidon[1].inputs[i] <== xwallsB[i];
    }

    //then hash them together to get the final game hash with salts
    poseidon[2].inputs[0] <== poseidon[0].out;
    poseidon[2].inputs[1] <== poseidon[1].out;
    poseidon[2].inputs[2] <== saltA;
    poseidon[2].inputs[3] <== saltB;

    out <== poseidon[2].out;
 }
// "n" is the sum number of the walls in final game map
component main = gameMap(8);