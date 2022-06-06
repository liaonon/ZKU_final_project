//[bonus] unit test for bonus.circom

//[assignment] write your own unit test to show that your Mastermind variation circuit is working as expected
const chai = require("chai");
const path = require("path");

const wasm_tester = require("circom_tester").wasm;

const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const assert = chai.assert;

describe("System of Bonus test", function () {
    this.timeout(100000000);

    it("Bonus question", async () => {
        const circuit = await wasm_tester("contracts/circuits/bonus.circom");
        await circuit.loadConstraints();
        
        const INPUT = {
            "leaf": "1",
            "path_elements": ["2", "1", "1"],
            "path_index": ["0", "0", "0"],
            "token": "1",
            "privHash": "4610321943328110277842313521214408653663692784002499608805076900859724043608"
            
        }
        //console.log("aw");

        const witness = await circuit.calculateWitness(INPUT, true);

        //console.log(witness);

    });
});



