// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "./BEBase.sol";

// this contract will transfer ownership to BETimelockController after deployed
// all onlyowner method would add timelock
contract BEEquipment is BEBase{
    constructor() ERC721("Crypto Elite's Equipment", "CEE") {}
}
