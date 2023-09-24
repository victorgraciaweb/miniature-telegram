// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importacion de Smart Contracts de OpenZeppelin
import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

contract ArtToken is ERC721, Ownable {

    // Constructor del Smart Contract
    constructor (string memory _name, string memory _symbol)
    ERC721(_name, _symbol){}

    // NFT token counter
    uint256 counter;

    // Pricing of NFT Tokens (price of the artwork)
    uint256 public fee = 5 ether;

    // Data structure with the properties of the artwork
    struct Art {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    // Storage structure for keeping artworks
    Art [] public art_works;

    // Declaration of an event
    event NewArtWork (address indexed owner, uint256 id, uint256 dna);

    // ============================================
    // Help functions
    // ============================================

    // Creation of a random number (required for NFT token properties)
    function _createRandomNum(uint256 _mod) internal view returns (uint256){
        bytes32 has_randomNum = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randonNum = uint256(has_randomNum);
        return randonNum % _mod;
    }

    // NFT Token Creation (Artwork)
    function _createArtWork(string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNum(1000));
        uint256 randDna = _createRandomNum(10**16);
        Art memory newArtWork = Art(_name, counter, randDna, 1, randRarity);
        art_works.push(newArtWork);
        _safeMint(msg.sender, counter);
        emit NewArtWork(msg.sender, counter, randDna);
        counter++;
    }

    // NFT Token Price Update
    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    // Visualize the balance of the Smart Contract (ethers)
    function infoSmartContract() public view returns(address, uint256){
        address SC_address = address(this);
        uint256 SC_money = address(this).balance / 10**18;
        return (SC_address, SC_money);
    }

    // Obtaining all created NFT tokens (artwork)
    function getArtWorks() public view returns (Art [] memory){
        return art_works;
    }

    // Obtaining a user's NFT tokens
    function getOwnerArtWork(address _owner) public view returns (Art [] memory){
        Art [] memory result = new Art[](balanceOf(_owner));
        uint256 counter_owner = 0;
        for (uint256 i = 0; i < art_works.length; i++){
            if (ownerOf(i) == _owner){
                result[counter_owner] = art_works[i];
                counter_owner++;
            }
        }
        return result;
    }
}