// SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.0;

contract FakeNFTMarketplace {
    // @dev Maintain a mapping of Fake ToenID to owner addresses
    mapping(uint256 => address) public tokens;
    // @dev Set the purchase price for each Fake NFT
    uint256 nftPrice = 0.1 ether;

    function purchase(uint256 _tokenId) external payable {
        require(msg.value == nftPrice, "This NFT costs 0.1 ether");
        tokens[_tokenId] = msg.sender;
    }

    // @dev getPrice() returns the price of one NFT
    function getPrice() external view returns (uint256) {
        return nftPrice;
    }

    

}