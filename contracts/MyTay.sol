pragma solidity ^0.5.12;

import "./Tay1155.sol";

/**
 * @title MyCollectible
 * MyCollectible - a contract for my semi-fungible tokens.
 */
contract MyTay is YatEmoji {
  constructor(address _proxyRegistryAddress)
  YatEmoji(
    "MyYat",
    "MYT",
    _proxyRegistryAddress
  ) public {
   _setBaseMetadataURI("https://creatures-api.opensea.io/api/creature/");
  }

  function contractURI() public view returns (string memory) {
    return "https://creatures-api.opensea.io/contract/opensea-erc1155";
  }
}
