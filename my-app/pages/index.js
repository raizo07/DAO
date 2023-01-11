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

    const connectWallet = async () => {
        try {
            await getProviderOrSigner();
            setWalletConnected(true);
        } catch (error) {
            console.error(error);
        }
    };

}
