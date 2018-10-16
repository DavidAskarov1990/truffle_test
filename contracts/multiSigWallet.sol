pragma solidity ^0.4.23;

interface Crowdsale {
    function isCrowdsaleClosed() external view returns(bool isClosed);
}

contract multiSigWallet  {
    struct Transaction {
        address destination;
        uint value;
        bytes data;
        bool executed;
    }

    event Confirmation(address owner, uint256 operation);
    event Submission(uint indexed transactionId);
    event Execution(uint indexed transactionId);
    event ExecutionFailure(uint indexed transactionId);
    event Transfer(uint indexed transactionId);

    uint constant public MAX_OWNER_COUNT = 5;
    mapping (uint => Transaction) public transactions;
    mapping (uint => mapping (address => bool)) public confirmations;
    mapping (address => bool) public isOwner;
    address[] public owners;
    uint public transactionCount = 1;
    uint public required = 3;
    address tokenContract;
    Crowdsale private crowdsaleContract;

    constructor() public {}

    modifier ownerExists(address owner) {
        require(isOwner[owner]);
        _;
    }

    modifier transactionExists(uint transactionId) {
        require(transactions[transactionId].destination != 0);
        _;
    }

    modifier confirmed(uint transactionId, address owner) {
        require(confirmations[transactionId][owner]);
        _;
    }

    modifier validRequirement(uint ownerCount, uint _required) {
        require(ownerCount <= MAX_OWNER_COUNT && _required <= ownerCount && _required != 0 && ownerCount != 0);
        _;
    }

    modifier notConfirmed(uint transactionId, address owner) {
        require(!confirmations[transactionId][owner]);
        _;
    }

    modifier notNull(address _address) {
        require(_address != 0, "You can set address");
        _;
    }

    modifier notExecuted(uint transactionId) {
        require(!transactions[transactionId].executed, "Transaction is already done");
        _;
    }

    function setCrowdsale(address c) ownerExists(msg.sender) {
        crowdsaleContract = Crowdsale(c);
    }

    function submitTransaction(address destination, uint value, bytes data) public returns (uint transactionId) {
        transactionId = addTransaction(destination, value, data);
        confirmTransaction(transactionId);
    }

    function addTransaction(address destination, uint value, bytes data) internal notNull(destination) returns (uint transactionId) {
        transactionId = ++transactionCount;
        transactions[transactionId] = Transaction({
            destination: destination,
            value: value,
            data: data,
            executed: false
            });
        emit Submission(transactionId);
        return transactionCount;
    }

    function confirmTransaction(uint transactionId) public ownerExists(msg.sender) transactionExists(transactionId) notConfirmed(transactionId, msg.sender) {
        confirmations[transactionId][msg.sender] = true;
        emit Confirmation(msg.sender, transactionId);
        executeTransaction(transactionId);
    }

    function executeTransaction(uint transactionId) public ownerExists(msg.sender) confirmed(transactionId, msg.sender) notExecuted(transactionId) {
        if (isConfirmed(transactionId)) {
            transactions[transactionId].executed = true;
            emit Execution(transactionId);
        }
    }

    function revokeConfirmation(uint transactionId) public ownerExists(msg.sender) {
        transactions[transactionId].executed = false;
        emit ExecutionFailure(transactionId);
    }

    function isConfirmed(uint transactionId) public constant returns (bool) {
        uint count = 0;
        for (uint i=0; i<owners.length; i++) {
            if (confirmations[transactionId][owners[i]]) {
                count += 1;
            }
        }
        if (count >= required) {
            return true;
        } else {
            return false;
        }
    }

    function transfer(uint transactionId) public  {
        require(transactions[transactionId].executed, "Transaction is not allowed");
        require(transactions[transactionId].value != 0, "Can't equal 0");
        require(crowdsaleContract.isCrowdsaleClosed(), "the transfer is not allow");
        if (isConfirmed(transactionId)) {
            transactions[transactionId].destination.send(transactions[transactionId].value);
            emit Transfer(transactionId);
        }
    }
}
