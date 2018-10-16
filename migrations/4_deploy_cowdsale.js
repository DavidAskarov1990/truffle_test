var ERC20 = artifacts.require("./erc20.sol");
var ERC2_NEW = artifacts.require("./erc20_new.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");
var MultiSigWallet = artifacts.require("./multiSigWallet.sol");
var MigrationAgent = artifacts.require("./migrateAgent.sol");

module.exports = async deployer => {
    try {
        console.log('Multi sig address -------> ', MultiSigWallet.address);
        await deployer.deploy(
            Crowdsale,
            MultiSigWallet.address,
            ERC20.address
        );
        console.log('---- Step 4 ----');
    } catch (error) {
        console.log(error);
    }

};
