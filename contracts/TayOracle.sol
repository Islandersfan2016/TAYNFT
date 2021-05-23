pragma solidity ^0.5.0;


import "@chainlink/contracts/src/v0.5/ChainlinkClient.sol";

contract TayOracle is ChainlinkClient {
  
    string public name;
    string public newOwnerEmail;
    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    /*
     * Fee: 0.1 LINK
     */
    constructor(address _oracle, string memory _jobId, uint256 _fee, address _link) public {
        if (_link == address(0)) {
            setPublicChainlinkToken();
        } else {
            setChainlinkToken(_link);
        }

            setPublicChainlinkToken();
            oracle = 0x0a31078cD57d23bf9e8e8F1BA78356ca2090569E; // matic network
            jobId = "d5bb786e502a41868abe8ebd792e4ea8";
            fee = 0.5 * 10 **18; // (fee varies by network and job)
        }
    
    /**
     * Create a Chainlink request to retrieve API response, find the target
     */
    
     function requestEthereumPrice(string memory _email) public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillEthereumPrice.selector);
        req.add("email", _email);
        sendChainlinkRequestTo(oracle, req, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function fulfillEthereumPrice(bytes32 _requestId, bytes32 _email) public recordChainlinkFulfillment(_requestId)
    {
        _email = _email;
    }

    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }
}
