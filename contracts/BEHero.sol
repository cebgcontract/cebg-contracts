// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "./BEBase.sol";

contract BEHero is BEBase{
    constructor() ERC721("Crypto Elite's Hero", "CEH") {}
}