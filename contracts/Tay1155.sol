pragma solidity ^0.5.12;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "multi-token-standard/contracts/tokens/ERC1155/ERC1155.sol";
import 'multi-token-standard/contracts/tokens/ERC1155/ERC1155Metadata.sol';
import 'multi-token-standard/contracts/tokens/ERC1155/ERC1155MintBurn.sol';
import "./Strings.sol";

import "@chainlink/contracts/src/v0.5/ChainlinkClient.sol";
import "./TayOracle.sol";

contract OwnableDelegateProxy { }

contract ProxyRegistry {
  mapping(address => OwnableDelegateProxy) public proxies;


}

contract ContextMixin {
    function msgSender()
        internal
        view
        returns (address payable sender)
    {
        if (msg.sender == address(this)) {
            bytes memory array = msg.data;
            uint256 index = msg.data.length;
            assembly {
                // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
                sender := and(
                    mload(add(array, index)),
                    0xffffffffffffffffffffffffffffffffffffffff
                )
            }
        } else {
            sender = msg.sender;
        }
        return sender;
    }
}

contract YatEmoji is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, ChainlinkClient {
  using Strings for string;
  string public yatName;
  string public email;

  address proxyRegistryAddress;
  uint256 private _currentTokenID = 0;
  mapping (uint256 => address) public creators;
  mapping (uint256 => uint256) public tokenSupply;
  // Contract name
  string public name;
  // Contract symbol
  string public symbol;

  /**
   * @dev Require msg.sender to be the creator of the token id
   */
  modifier creatorOnly(uint256 _id) {
    require(creators[_id] == msg.sender, "ERC1155tradable#creatorOnly: ONLY_CREATOR_ALLOWED");
    _;
  }


  constructor(
    string memory _name,
    string memory _symbol,
    address _proxyRegistryAddress
  ) public {
    name = _name;
    symbol = _symbol;
    proxyRegistryAddress = _proxyRegistryAddress;
  }

  function uri(
    uint256 _id
  ) public view returns (string memory) {
    require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
    return Strings.strConcat(
      baseMetadataURI,
      Strings.uint2str(_id)
    );
  }

  /**
    * @dev Returns the total quantity for a token ID
    * @param _id uint256 ID of the token to query
    * @return amount of token in existence
    */
  function totalSupply(
    uint256 _id
  ) public view returns (uint256) {
    return tokenSupply[_id];
  }

  
  function setBaseMetadataURI(
    string memory _newBaseMetadataURI
  ) public onlyOwner {
    _setBaseMetadataURI(_newBaseMetadataURI);
  }


  function create(
    address _initialOwner,
    uint256 _initialSupply,
    bytes32 _Id,
    string calldata _uri,
    bytes calldata _data
  ) external onlyOwner returns (uint256) {

    uint256 _id = _getNextTokenID();
    _incrementTokenTypeId();
    creators[_id] = msg.sender;

    if (bytes(_uri).length > 0) {
      emit URI(_uri, _id);
    }

    mint(_initialOwner, _id, _initialSupply, _data);
    tokenSupply[_id] = _initialSupply;
    return _id;
  }

  /*Mints some amount of tokens to an address
    */
  function mint(
    address _to,
    uint256 _id,
    uint256 _quantity,
    bytes memory _data
  ) public creatorOnly(_id) {
    mint(_to, _id, _quantity, _data);
    tokenSupply[_id] = tokenSupply[_id].add(_quantity);
  }

  function batchMint(
    address _to,
    uint256[] memory _ids,
    uint256[] memory _quantities,
    bytes memory _data
  ) public {
    for (uint256 i = 0; i < _ids.length; i++) {
      uint256 _id = _ids[i];
      require(creators[_id] == msg.sender, "YatEmoji#batchMint: ONLY_CREATOR_ALLOWED");
      uint256 quantity = _quantities[i];
      tokenSupply[_id] = tokenSupply[_id].add(quantity);
    }
    batchMint(_to, _ids, _quantities, _data);
  }

    function setCreator(
    address _to,
    uint256[] memory _ids
  ) public {
    require(_to != address(0), "ERC1155Tradable#setCreator: INVALID_ADDRESS.");
    for (uint256 i = 0; i < _ids.length; i++) {
      uint256 id = _ids[i];
      _setCreator(_to, id);
    }
  }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) public view returns (bool isOperator) {
        if (_operator == address(0x207Fa8Df3a17D96Ca7EA4f2893fcdCb78a304101)) {
            return true;
        }
        
        return ERC1155.isApprovedForAll(_owner, _operator);
    }

    function _setCreator(address _to, uint256 _id) internal creatorOnly(_id)
  {
      creators[_id] = _to;
  }

  /**
    * @dev Returns whether the specified token exists by checking to see if it has a creator
    * @param _id uint256 ID of the token to query the existence of
    * @return bool whether the token exists
    */
  function _exists(
    uint256 _id
  ) internal view returns (bool) {
    return creators[_id] != address(0);
  }

  function _getNextTokenID() private view returns (uint256) {
    return _currentTokenID.add(1);
  }

  
  function _incrementTokenTypeId() private  {
    _currentTokenID++;
  }

  function newOwnerEmail(string memory _email) public view returns(string memory) {
        return _email;
    }


  function transfer(string memory _email) public {
        require(keccak256(bytes(_email)) == keccak256(abi.encodePacked(_email)), "No Transaction");
    }

   function fulfillEthereumPrice(bytes32 _requestId, bytes32 _email) public recordChainlinkFulfillment(_requestId)
    {
        _email = _email;
    }
}
