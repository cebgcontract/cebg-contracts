// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./HasSignature.sol";

// this contract will transfer ownership to BETimelockController after deployed
// all onlyowner method would add timelock

interface IBurnableERC721 is IERC721 {
    function burn(address owner, uint256 tokenId) external;
}
contract EvolveProxy is Ownable, Initializable, HasSignature {

    IBurnableERC721 public hero;
    IBurnableERC721 public equip;
    IBurnableERC721 public chip;

    mapping(bytes => bool) public usedSignatures;

    address public executor;

    event TokenEvolved(
        uint256 indexed evolveEventId,
        address indexed owner,
        uint256 tokenEvolved,
        uint256 tokenBurned,
        uint256 chip
    );

    constructor()
        HasSignature("EvolveProxy", "1"){
    }

    function init(address[3] calldata _erc721s) external initializer onlyOwner {
        hero = IBurnableERC721(_erc721s[0]);
        equip = IBurnableERC721(_erc721s[1]);
        chip = IBurnableERC721(_erc721s[2]);
    }

    /**
     * @dev update executor
     */
    function updateExecutor(address account) external onlyOwner {
        require(account != address(0), 'address can not be zero');
        executor = account;
    }

    /**
     * @dev evolve function to Blissful Elites Hero NFT
     * tokenIds: [hero_to_evolve, hero_for_burn, chip]
     */
    function evolveHero(
        uint256 evolveEventId,
        uint256[3] calldata tokenIds,
        uint256 saltNonce,
        bytes calldata signature
    ) external {
        require(
            tokenIds[0] > 0 && tokenIds[1] > 0, 
            "EvolveProxy: hero to evolve and burn can not be 0"
        );

        require(
            tokenIds[0] != tokenIds[1],
            "EvolveProxy: hero to evolve and burn can not be same"
        );
        
        require(
            hero.ownerOf(tokenIds[0]) == msg.sender, 
            "EvolveProxy: not owner of this hero now"
            );

        require(
            !usedSignatures[signature],
            "EvolveProxy: signature used. please send another transaction with new signature"
        );
        bytes32 criteriaMessageHash = getMessageHash(
            evolveEventId,
            tokenIds[0],
            tokenIds[1],
            tokenIds[2],
            saltNonce
        );
        checkSigner(executor, criteriaMessageHash, signature);
        hero.burn(msg.sender, tokenIds[1]);
        if (tokenIds[2] > 0) {
            chip.burn(msg.sender, tokenIds[2]);
        }
        emit TokenEvolved(evolveEventId, msg.sender, tokenIds[0], tokenIds[1], tokenIds[2]);
    }

    /**
     * @dev evolve function to Blissful Elites Equip NFT
     * tokenIds: [equip_to_evolve, equip_for_burn, chip]
     */
    function evolveEquip(
        uint256 evolveEventId,
        uint256[3] calldata tokenIds,
        uint256 saltNonce,
        bytes calldata signature
    ) external{
        require(
            tokenIds[0] > 0 && tokenIds[1] > 0, 
            "EvolveProxy: equip to evolve and burn can not be 0"
        );

        require(
            tokenIds[0] != tokenIds[1],
            "EvolveProxy: equip to evolve and burn can not be same"
        );

        require(
            equip.ownerOf(tokenIds[0]) == msg.sender, 
            "EvolveProxy: current address is not owner of this equip now"
            );

        require(
            !usedSignatures[signature],
            "EvolveProxy: signature used. please send another transaction with new signature"
        );
        bytes32 criteriaMessageHash = getMessageHash(
            evolveEventId,
            tokenIds[0],
            tokenIds[1],
            tokenIds[2],
            saltNonce
        );
        checkSigner(executor, criteriaMessageHash, signature);
        equip.burn(msg.sender, tokenIds[1]);
        if (tokenIds[2] > 0) {
            chip.burn(msg.sender, tokenIds[2]);
        }
        emit TokenEvolved(evolveEventId, msg.sender, tokenIds[0], tokenIds[1], tokenIds[2]);
    }

    function getMessageHash(
        uint256 _eventId,
        uint256 _mainToken,
        uint256 _burnToken,
        uint256 _chipToken,
        uint256 _saltNonce
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    _eventId,
                    _mainToken,
                    _burnToken,
                    _chipToken,
                    _saltNonce
                )
            );
    }

}