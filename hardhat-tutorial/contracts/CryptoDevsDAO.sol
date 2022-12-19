// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketplace {

    function getprice() external view returns (uint256);

    function available(uint256 _tokenId) external view returns (bool);

    function purchase(uint256 _tokenId) external payable;

}


interface ICryptoDevsNFT {
    function balanceOf(address owner) external view returns (uint256);
    

    function tokenOfOwnerByIndex(address owner, uint256 index)
    external
    view
    returns (uint256);
}



contract CrytoDevsDAO is Ownable {

struct Proposal {
    uint256 nftTokenId;

    uint256 deadline;

    uint256 yayVotes;

    uint256 nayVotes;

    bool executed;

    mapping(uint256 => bool) voters;

    mapping(uint256 => Proposal) public proposals;

    uint256 public numProposals;

    IFakeNFTMarketplace nftMarketplace;
    ICryptoDevsnf cryptoDevsNFT;


    constructor(address _nftMarketplace, address _cryptoDevsNFT) payable
        nftMarketplace = IFakeNFTMarketplace(_nftMarketplace);
        cryptoDevsNFT = ICryptoDevsNFT(_cryptoDevsNFT);

}
}