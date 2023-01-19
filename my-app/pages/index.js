import { Contract, providers } from "ethers";
import { formatEther } from "ethers/lib/utils";
import Head from "next/head";
import { useEffect, useRef, useState } from "react";
import web3Modal from "web3modal";
import { 
    CRYPTODEVS_DAO_ABI,
    CRYPTODEVS_DAO_CONTRACT_ADDRESS,
    CRYPTODEVS_NFT_ABI,
    CRYPTODEVS_NFT_CONTRACT_ADDRESS
} from "../constants";
import styles from "../styles/Home.modules.css";

export default function Home() {
    const[treasuryBalance, setTreasurybalance] = useState("0");
    const [numProposals, setNumberOfproposals] = useState("0");
    const [proposals, setProposals] = useState([]);
    const [nftBalance, setNftBalance] = useState("0");
    const [fakeNftTokenId, setFakeNftTokenId] = useState("");
    const [selectedTab, setSelectedTab] = useState("");
    const [loading, setLoading] = useState(false);
    const [walletConnected, setWalletConnected] = useState(false);
    const [isOwner, setIsOwner] = useState(false);
    const web3Modal = useRef();

    // Helper funmction to connect wallet
    const connectWallet = async () => {
        try {
            await getProviderOrSigner();
            setWalletConnected(true);
        } catch (error) {
            console.error(error);
        }
    };

    /**
     * getOwner: gets the contract owner by connected address
     */

    const getDAOOwner = async () => {
        try {
            const signer = await getProviderOrSigner(true);
            const contract = getDaoContractInstance(signer);

            //Call the owner function from the contract
            const _owner = await contract.owner();
            // Get the address that is associated to signer which is connected to Metamask
             const address = await signer.getAddress();
             if (address.toLowerCase() === _owner.toLowerCase()) {
                setIsOwner(true);
             } 
        } catch (err) {
            console.error(err.message);
        }
    };


    /**
     * withdrawCoins: withdraw ether by calling
     * the withdraw function
     */

    const withdrawDAOEther = async () => {
        try {
            const signer = await getProviderOrSigner(true);
            const contract = await getDaoContractInstance(signer);

            const tx = await contract.withdrawEther();
            setLoading(true);
            await tx.wait();
            setLoading(false);
            getDAOTreausryBalance();
        } catch (err) {
            console.error(err);
            window.alert(err.reason);
        }
    };

    // Read the ETH balance of the DAO contract and sets the `treasuryBalance` state variable
    const getDAOTreausryBalance = async () => {
        try {
            const provider = await getProviderOrSigner();
            const balance = await provider.getBalance(
                CRYPTODEVS_DAO_CONTRACT_ADDRESS
            );
            setTreasurybalance(balance.toString());
        } catch (error) {
            console.error(error)
        }
    };

    //Read the number of proposals in the DAO contract and sets the `numProposals` state variable
    const getNumProposalsInDAO = async () => {
        try {
            const provider = await getProviderOrSigner();
            const contract = getDaoContractInstance(provider);
            const daoNumProposals = await contract.numProposals();
            setNumberOfproposals(daoNumProposals.toString());
        } catch (error) {
            console.error(error);
        }
    };


    // Reads the balance of the user's CryptoDevs NFTs and sets the `nftBalance` state variable
    const getUserNFTBalance = async () => {
        try {
            const signer = await getProviderOrSigner(true);
            const nftContract = getCryptodevsNFTContractInstance(signer);
            const balance = await nftContract.balanceOf(signer.getAddress());
            setNftBalance(parseInt(balance.toString()));
        } catch (error) {
            console.error(error);
        }
    };

    // calls the `createProposal` function in the contract, using the tokenId from `fakeNftTokenId`
    const createProposal = async () => {
        try {
            const signer = await getProviderOrSigner(true);
            const daoContract = getDaoContractInstance(signer);
            const txn = await daoContract.createPropossal(fakeNftTokenId);
            setLoading(true);
            await txn.wait();
            await getNumProposalsInDAO();
            setLoading(false);
        } catch (error) {
            console.error(error);
            window.alert(error.reason);
        }
    };







}
