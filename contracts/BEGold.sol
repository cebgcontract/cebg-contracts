// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
/**
 * this contract will transfer ownership to BETimelockController after deployed
 * all onlyowner method would add timelock
 */
contract BEGold is ERC20, ERC20Burnable, Pausable, Ownable {

    uint256 public constant INITIALIZED_CAP = 100000000 * 1e18;

    constructor() ERC20("Crypto Elite's Gold", "CEG") {
        _mint(msg.sender, INITIALIZED_CAP);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}