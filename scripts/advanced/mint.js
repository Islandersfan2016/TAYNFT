const HDWalletProvider = require("truffle-hdwallet-provider");
const web3 = require("web3");
const MNEMONIC = process.env.MNEMONIC;
const NODE_API_KEY = process.env.MATIC_URI || process.env.ALCHEMY_KEY;
const isMatic = !!process.env.MATIC_URI;
const FACTORY_CONTRACT_ADDRESS = process.env.FACTORY_CONTRACT_ADDRESS;
const NFT_CONTRACT_ADDRESS = process.env.NFT_CONTRACT_ADDRESS;
const OWNER_ADDRESS = process.env.OWNER_ADDRESS;
const NETWORK = process.env.NETWORK;
const NUM_EMOJIS = 12;
const NUM_LOOTBOXES = 4;
const DEFAULT_OPTION_ID = 0;
const LOOTBOX_OPTION_ID = 2;

const NFT_ABI = [
  {
    constant: false,
    inputs: [
      {
        name: "_to",
        type: "address",
      },
    ],
    name: "mintTo",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
];

const FACTORY_ABI = [
  {
    constant: false,
    inputs: [
      {
        name: "_optionId",
        type: "uint256",
      },
      {
        name: "_toAddress",
        type: "address",
      },
    ],
    name: "mint",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
];

async function main() {
  const network =
    NETWORK === "mainnet" || NETWORK === "live" ? "mainnet" : "matic";
  const provider = new HDWalletProvider(
    "insect borrow repair hammer goddess battle matrix group diet satoshi rotate worry",
    "https://rpc-mumbai.matic.today");
  const web3Instance = new web3(provider);

  if (FACTORY_CONTRACT_ADDRESS) {
    const factoryContract = new web3Instance.eth.Contract(
      FACTORY_ABI,
      FACTORY_CONTRACT_ADDRESS,
      { gasLimit: "1000000" }
    );

    // Creatures issued directly to the owner.
    for (var i = 0; i < NUM_EMOJIS; i++) {
      const result = await factoryContract.methods
        .mint(DEFAULT_OPTION_ID, "0xC55fDa37B063c628431A40BFBA04232C89ffE31E")
        .send({ from: "0xC55fDa37B063c628431A40BFBA04232C89ffE31E" });
      console.log("Minted emoji. Transaction: " + result.transactionHash);
    }

    // Lootboxes issued directly to the owner.
    for (var i = 0; i < NUM_LOOTBOXES; i++) {
      const result = await factoryContract.methods
        .mint(LOOTBOX_OPTION_ID, "0xC55fDa37B063c628431A40BFBA04232C89ffE31E")
        .send({ from: "0xC55fDa37B063c628431A40BFBA04232C89ffE31E" });
      console.log("Minted lootbox. Transaction: " + result.transactionHash);
    }
  } else if (NFT_CONTRACT_ADDRESS) {
    const nftContract = new web3Instance.eth.Contract(
      NFT_ABI,
      NFT_CONTRACT_ADDRESS,
      { gasLimit: "1000000" }
    );

    // Emojis issued directly to the owner.
    for (var i = 0; i < NUM_EMOJIS; i++) {
      const result = await nftContract.methods
        .mintTo("0xC55fDa37B063c628431A40BFBA04232C89ffE31E")
        .send({ from: "0xC55fDa37B063c628431A40BFBA04232C89ffE31E" });
      console.log("Minted. Transaction: " + result.transactionHash);
    }
  } else {
    console.error(
      "Add NFT_CONTRACT_ADDRESS or FACTORY_CONTRACT_ADDRESS to the environment variables"
    );
  }
}

main();