pragma solidity ^0.4.23;

contract IMigrationAgent {
    function transfer(address _from, uint _value) external;
    function finalizeMigration() external;
}