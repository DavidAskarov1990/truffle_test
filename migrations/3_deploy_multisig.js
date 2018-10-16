var ERC20 = artifacts.require("./erc20.sol");
var ERC2_NEW = artifacts.require("./erc20_new.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");
var MultiSigWallet = artifacts.require("./multiSigWallet.sol");
var MigrationAgent = artifacts.require("./migrateAgent.sol");

module.exports = async deployer => {
    console.log('---------------> ERC20 address', ERC20.address);
    await deployer.deploy(
        MultiSigWallet
    );
};
