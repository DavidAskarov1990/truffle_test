pragma solidity ^0.4.23;

import "./shared/Owner.sol";

contract erc20_new {
    function totalSupply() constant returns (uint256);
    function finalizeMigration();
    function createToken(address _from, uint _value);
}

contract erc20 {
    function totalSupply() constant returns (uint256);
}

contract migrateAgent is Ownable {
    address owner;
    address sourceToken;
    address targetToken;
    uint256 tokenSupply;
    erc20 public tokenContract;
    erc20_new public targetContract;

    constructor(address _sourceToken) public {
        sourceToken = _sourceToken;
        tokenSupply = 10000;
    }

    function setTargetToken(address _token) onlyOwner {
        require(targetToken == 0, "Not set target token");
        targetToken = _token;
    }

    function transfer(address _from, uint _value) {
        require(msg.sender == sourceToken, "Not permission");
        require(targetToken != 0);
        safetyInvariantCheck(_value);
        targetContract.createToken(_from, _value);
    }

    function safetyInvariantCheck(uint _value) private {
        require(targetToken != 0, "Tokens is out");
        require(targetContract.totalSupply() + targetContract.totalSupply() == tokenSupply - _value);
    }

    function finalizeMigration() onlyOwner {
        safetyInvariantCheck(0);
        targetContract.finalizeMigration();
        sourceToken = 0;
        targetToken = 0;
        tokenSupply = 0;
    }
}
