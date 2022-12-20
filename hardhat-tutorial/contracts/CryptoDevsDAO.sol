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

        modifier nftHolderOnly() {
            require(cryptodevsNFT.balanceOf(msg.sender) > 0, "NOT-A-DAO-MEMBER");
            _;
        }

        function createproposal(uint256 _nftTokenId) 
            external
            nftHolderOnly
            returns (uint256)
        {
            require(nftMarketplace.available(_nftTokenId), "NFT-NOT-FOR-SALE");
            Proposal storage proposal = proposals[numproposals];
            proposal.nftTokenId =_nftTokenId;
            // Set the proposal's voting deadline to be (current time + 5 minutes)
            proposal.deadline = block.timestamp + 5 minutes;

            numProposals++;

            return numproposals - 1;

        }

modifier activeProposalOnly(uint256 proposalindex) {
    require(
        proposals[proposalIndex].deadline > block.timestamp,
        "DEADLINE_EXCEEDED"
    );
    _;
}
// Create an enum named Vote containing possible options for a vote
enum Vote {
    YAY,
    NAY
}

}
}