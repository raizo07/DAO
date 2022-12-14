// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketplace {

    function getPrice() external view returns (uint256);

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



contract CryptoDevsDAO is Ownable {

struct Proposal {
    uint256 nftTokenId;

    uint256 deadline;

    uint256 yayVotes;

    uint256 nayVotes;

    bool executed;

    mapping(uint256 => bool) voters;
}

    mapping(uint256 => Proposal) public proposals;

    uint256 public numProposals;

    IFakeNFTMarketplace nftMarketplace;
    ICryptoDevsNFT cryptoDevsNFT;


    constructor(address _nftMarketplace, address _cryptoDevsNFT) payable {
        nftMarketplace = IFakeNFTMarketplace(_nftMarketplace);
        cryptoDevsNFT = ICryptoDevsNFT(_cryptoDevsNFT);
}
        modifier nftHolderOnly() {
            require(cryptoDevsNFT.balanceOf(msg.sender) > 0, "NOT-A-DAO-MEMBER");
            _;
        }

        function createproposal(uint256 _nftTokenId) 
            external
            nftHolderOnly
            returns (uint256)
        {
            require(nftMarketplace.available(_nftTokenId), "NFT-NOT-FOR-SALE");
            Proposal storage proposal = proposals[numProposals];
            proposal.nftTokenId =_nftTokenId;
            // Set the proposal's voting deadline to be (current time + 5 minutes)
            proposal.deadline = block.timestamp + 5 minutes;

            numProposals++;

            return numProposals - 1;

        }

modifier activeProposalOnly(uint256 proposalIndex) {
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

function voteOnProposal(uint256 proposalIndex, Vote vote) 
    external
    nftHolderOnly
    activeProposalOnly(proposalIndex)
{
    Proposal storage proposal = proposals[proposalIndex];

    uint256 voterNFTBalance =cryptoDevsNFT.balanceOf(msg.sender);
    uint256 numVotes = 0;

    // Calculate how many NFTs are owned by the voter that have not yet been used for voting on this proposal

    for (uint256 i = 0; i < voterNFTBalance; i++) {
        uint256 tokenId = cryptoDevsNFT.tokenOfOwnerByIndex(msg.sender, i);
        if (proposal.voters[tokenId] == false) {
            numVotes++;
            proposal.voters[tokenId] = true;
        }
    }
    require(numVotes > 0, "ALREADY_VOTED");

    if (vote == Vote.YAY) {
        proposal.yayVotes += numVotes;
    } else {
        proposal.nayVotes += numVotes;
    }

}


modifier inactiveProposalOnly(uint256 proposalIndex) {
    require(
        proposals[proposalIndex].deadline <= block.timestamp,
        "DEADLINE-NOT-EXCEEDED"
    );
    require(
        proposals[proposalIndex].executed == false,
        "PROPOSAL-ALREADY-EXECUTED"
    );
    _;
}

function executeProposal(uint256 proposalIndex) 
    external
    nftHolderOnly
    inactiveProposalOnly(proposalIndex)
{
    Proposal storage proposal = proposals[proposalIndex];

    if (proposal.yayVotes > proposal.nayVotes) {
        uint256 nftPrice = nftMarketplace.getPrice();
        require(address(this).balance >= nftPrice, "NOT-ENOUGH-FUNDS");
        nftMarketplace.purchase{value: nftPrice}(proposal.nftTokenId);
     }
     proposal.executed = true;
}

/// @dev withdrawEther allows the contract owner (deployer) to withdraw the ETH from the contract
function withdrawEther() external onlyOwner {
    uint256 amount = address(this).balance;
    require(amount > 0, "Nothing to withdraw, contract balance is empty");
    payable(owner()).transfer(amount);
}

receive() external payable {}

fallback() external payable {}


















}








