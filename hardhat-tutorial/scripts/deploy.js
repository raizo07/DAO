const { ethers } = require("hardhat");
const { CRYPTODEVS_NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {
    // Deploy the FakeNFTMarketplace contract first
    const FakeNFTMarketplace = await ethers.getContractFactory(
        "FakeNFTMarketplace"
    );
    const fakeNftMarketplace = await FakeNFTMarketplace.deploy();
    await fakeNftMarketplace.deployed();

    console.log("FakeNFTMarketplace deployed to: ", fakeNftMarketplace.address);

    // deploy the CryptoDevsDAO contract
    const CryptoDevsDAO = await ethers.getContractFactory("CryptoDevsDAO");
    CryptoDevsDAO = await CryptoDevsDAO.deploy(
        fakeNftMarketplace.address,
        CRYPTODEVS_NFT_CONTRACT_ADDRESS,
        {
            value: ethers.utils.parseEther("1"),
        }
    );
    await CryptoDevsDAO.deployed();

    console.log("CryptoDevsDAO deployed to: ", CryptoDevsDAO.address);
}

main() 
    .then(() => PromiseRejectionEvent.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });