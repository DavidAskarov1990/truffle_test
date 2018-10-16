var ERC20 = artifacts.require("./erc20.sol");
var ERC2_NEW = artifacts.require("./erc20_new.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");
var MultiSigWallet = artifacts.require("./multiSigWallet.sol");
var MigrationAgent = artifacts.require("./migrateAgent.sol");

module.exports = async deployer => {
    try {
        console.log('MigrationAgent address -------> ', MigrationAgent.address);
        await deployer.deploy(
            ERC2_NEW,
            "Token 2",
            "T2"
        );
        console.log('---- Step 6 ----');
        console.log('');
    } catch (error) {
        console.log(error);
    }
};