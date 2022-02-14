// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "@openzeppelin/contracts/governance/TimelockController.sol";

contract BETimelockController is TimelockController {
  uint256 public constant MIN_DELAY = 2 days;
  uint256 public constant MAX_DELAY = 16 days;
  uint256 private _minDelay;

  constructor(
    address[] memory proposers, 
    address[] memory executors)
    TimelockController(MIN_DELAY, proposers, executors){
      _minDelay = MIN_DELAY;
  }


  /**
     * @dev Returns the minimum delay for an operation to become valid.
     *
     * This value can be changed by executing an operation that calls `updateDelay`.
     */
    function getMinDelay() public view virtual override returns (uint256 duration) {
        return _minDelay;
    }

  /**
     * @dev Changes the minimum timelock duration for future operations.
     *
     * Emits a {MinDelayChange} event.
     *
     * Requirements:
     *
     * - the caller must be the timelock itself. This can only be achieved by scheduling and later executing
     * an operation where the timelock is the target and the data is the ABI-encoded call to this function.
     */
    function updateDelay(uint256 newDelay) external virtual override {
        require(msg.sender == address(this), "BETimelockController: caller must be timelock");
        require(newDelay >= MIN_DELAY);
        require(newDelay <= MAX_DELAY);
        emit MinDelayChange(_minDelay, newDelay);
        _minDelay = newDelay;
    }
}

