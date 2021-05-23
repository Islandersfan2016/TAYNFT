const MyTay = artifacts.require("MyTay");

// Set to false if you only want the collectible to deploy
const ENABLE_LOOTBOX = true;
// Set if you want to create your own collectible
const NFT_ADDRESS_TO_USE = undefined; // e.g. Enjin: '0xfaafdc07907ff5120a76b34b731b278c38d6043c'
// If you want to set preminted token ids for specific classes
const TOKEN_ID_MAPPING = undefined; // { [key: number]: Array<[tokenId: string]> }

module.exports = function(deployer, network) {
  // OpenSea proxy registry addresses for rinkeby and mainnet.
  let proxyRegistryAddress;
  if (network === 'matic') {
    proxyRegistryAddress = "0x207Fa8Df3a17D96Ca7EA4f2893fcdCb78a304101";
  } else {
    proxyRegistryAddress = "0xa5409ec958c83c3f309868babaca7c86dcb077c1";
  }
}
