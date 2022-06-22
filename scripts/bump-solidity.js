const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/

//checkWall
let content = fs.readFileSync("./contracts/checkWall.sol", { encoding: 'utf-8' });
let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
fs.writeFileSync("./contracts/checkWall.sol", bumped);

//gameMap
content = fs.readFileSync("./contracts/gameMap.sol", { encoding: 'utf-8' });
bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
fs.writeFileSync("./contracts/gameMap.sol", bumped);

//checkBrokenWall
content = fs.readFileSync("./contracts/checkBrokenWall.sol", { encoding: 'utf-8' });
bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
fs.writeFileSync("./contracts/checkBrokenWall.sol", bumped);

//setBrokenWall
content = fs.readFileSync("./contracts/setBrokenWall.sol", { encoding: 'utf-8' });
bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
fs.writeFileSync("./contracts/setBrokenWall.sol", bumped);