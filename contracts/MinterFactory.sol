// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IMintableERC721 is IERC721 {
    function mint(address to, uint256 tokenId) external;
}

contract MinterFactory is Ownable, Initializable {
    // NFT contract
    IMintableERC721 public hero;
    IMintableERC721 public equip;
    IMintableERC721 public chip;


    event TokenMinted(
        address contractAddress,
        address to,
        uint256 indexed tokenId
    );

    function init(address[3] calldata _erc721s) external initializer onlyOwner {
        hero = IMintableERC721(_erc721s[0]);
        equip = IMintableERC721(_erc721s[1]);
        chip = IMintableERC721(_erc721s[2]);
    }

    /**
     * @dev mint function to distribute Blissful Elites Hero NFT to user
     */
    function mintHeroTo(address to, uint256 tokenId) external onlyOwner{
        require(to != address(0), 'to address can not be zero');
        hero.mint(to, tokenId);
        emit TokenMinted(address(hero), to, tokenId);
    }

    /**
     * @dev mint function to distribute Blissful Elites Equipment NFT to user
     */
    function mintEquipTo(address to, uint256 tokenId) external onlyOwner{
        require(to != address(0), 'to address can not be zero');
        equip.mint(to, tokenId);
        emit TokenMinted(address(equip), to, tokenId);
    }

    /**
     * @dev mint function to distribute Blissful Elites Chip NFT to user
     */
    function mintChipTo(address to, uint256 tokenId) external onlyOwner{
        require(to != address(0), 'to address can not be zero');
        chip.mint(to, tokenId);
        emit TokenMinted(address(chip), to, tokenId);
    }

}
