const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/

let content = fs.readFileSync("./contracts/textProof.sol", { encoding: 'utf-8' });
let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');

fs.writeFileSync("./contracts/textProof.sol", bumped);

content = fs.readFileSync("./contracts/checkToken.sol", { encoding: 'utf-8' });
bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');

fs.writeFileSync("./contracts/checkToken.sol", bumped);