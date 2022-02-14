// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";
import "./HasSignature.sol";

contract BEBoxMall is Ownable, HasSignature, TimelockController{
    using SafeERC20 for IERC20;
    using Address for address;

    uint256 public constant MIN_DELAY = 2 days;
    uint256 public constant MAX_DELAY = 16 days;
    uint256 private _minDelay;

    bool public address_initialized;

    constructor(
        address[] memory proposers, 
        address[] memory executors)
        TimelockController(MIN_DELAY, proposers, executors){
        _minDelay = MIN_DELAY;
        address_initialized = false;
    }

    event BEBoxPaid(
        uint256 indexed boxId,
        address indexed buyer,
        uint256 boxType,
        uint256 price,
        address paymentToken
    );

    address public paymentReceivedAddress;
    mapping(bytes => bool) public usedSignatures;

    function setPaymentReceivedAddress(address _paymentReceivedAddress)
        public
    {
        require(_paymentReceivedAddress != address(0), 'BEBoxMall::setPaymentReceivedAddress: payment received address can not be zero');
        if (address_initialized) {
            require(msg.sender == address(this), "BEBoxMall::setPaymentReceivedAddress: Call must come from BEBoxMall.");
        } else {
            require(msg.sender == owner(), "BEBoxMall::setPaymentReceivedAddress: First call must come from owner.");
            address_initialized = true;
        }
        paymentReceivedAddress = _paymentReceivedAddress;
    }

    /**
     * @dev BE box payment function
     */
    function payForBoxWithSignature(
        uint256 boxId,
        uint256 _type,
        address userAddress,
        uint256 price,
        address paymentErc20,
        uint256 saltNonce,
        bytes calldata signature
    ) external onlyOwner {
        require(
            !userAddress.isContract(),
            "BEBoxPayment: Only user address is allowed to buy box"
        );
        require(_type > 0, "BEBoxPayment: Invalid box type");
        require(price > 0, "BEBoxPayment: Invalid payment amount");
        require(
            !usedSignatures[signature],
            "BEBoxPayment: signature used. please send another transaction with new signature"
        );
        bytes32 criteriaMessageHash = getMessageHash(
            _type,
            paymentErc20,
            price,
            saltNonce
        );

        checkSigner(userAddress, criteriaMessageHash, signature);

        IERC20 paymentToken = IERC20(paymentErc20);
        uint256 allowToPayAmount = paymentToken.allowance(
            userAddress,
            address(this)
        );
        require(
            allowToPayAmount >= price,
            "BEBoxPayment: Invalid token allowance"
        );
        // Transfer payment
        paymentToken.safeTransferFrom(
            userAddress,
            paymentReceivedAddress,
            price
        );
        usedSignatures[signature] = true;
        // Emit payment event
        emit BEBoxPaid(boxId, userAddress, _type, price, paymentErc20);
    }

    function getMessageHash(
        uint256 _boxType,
        address _paymentErc20,
        uint256 _price,
        uint256 _saltNonce
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(_boxType, _paymentErc20, _price, _saltNonce)
            );
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
        require(msg.sender == address(this), "BEBoxMall: caller must be timelock");
        require(newDelay >= MIN_DELAY);
        require(newDelay <= MAX_DELAY);
        emit MinDelayChange(_minDelay, newDelay);
        _minDelay = newDelay;
    }
}
