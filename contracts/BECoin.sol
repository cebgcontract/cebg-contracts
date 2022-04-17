// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract BECoin is ERC20Burnable {
    uint256 public constant INITIALIZED_CAP = 100000000 * 1e18;

    constructor() ERC20("CRYPTO ELITE'S COIN", "CEC") {
        _mint(_msgSender(), INITIALIZED_CAP);
    }
}