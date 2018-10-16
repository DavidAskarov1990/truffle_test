pragma solidity ^0.4.23;

import "./shared/Owner.sol";

contract erc20
{
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Crowdsale is Ownable
{
    address public multisigContractAddress;
    erc20 public tokenContract;

    uint public deadline;
    uint public bonusDeadline;
    uint public price;
    uint public bonusPrice;
    uint8 public investorCount;

    bool private fundingGoalReached = false;
    bool private crowdsaleClosed = false;

    event GoalReached(address recipient);
    event FundTransfer(address backer, uint amount);

    constructor (address _multisigContractAddress, address _tokenAddress) public
    {
        multisigContractAddress = _multisigContractAddress;
        setERC20TokenAddress(_tokenAddress);

        deadline = 10080 minutes;
        bonusDeadline = 2880 minutes;
        price = 0.25 ether;
        bonusPrice = 0.225 ether;
        investorCount = 0;
    }

    function setERC20TokenAddress(address tokenAddress) private onlyOwner
    {
        tokenContract = erc20(tokenAddress);
    }

    function() payable public afterDeadline
    {
        require(!crowdsaleClosed);

        uint amount = msg.value;
        uint tokensForTransfer;

        if (now <= bonusDeadline)
        {
            tokensForTransfer = amount / bonusPrice;
        }
        else
        {
            tokensForTransfer = amount / price;
        }

        if (investorCount <= 5)
        {
            tokensForTransfer += tokensForTransfer / 100 * 20;
            investorCount++;
        }

        tokensForTransfer += (tokensForTransfer % 100);

        require(tokensForTransfer >= tokenContract.balanceOf(this));

        multisigContractAddress.transfer(amount);
        tokenContract.transfer(msg.sender, tokensForTransfer);
        emit FundTransfer(msg.sender, amount);
    }

    modifier afterDeadline()
    {
        if (now >= deadline)
            _;
    }

    function checkGoalReached() public afterDeadline
    {
        if(tokenContract.balanceOf(this) == 0)
        {
            fundingGoalReached = true;
            emit GoalReached(multisigContractAddress);
        }
        crowdsaleClosed = true;
    }

    function isCrowdsaleClosed() public view returns(bool isClosed)
    {
        return crowdsaleClosed;
    }
}
