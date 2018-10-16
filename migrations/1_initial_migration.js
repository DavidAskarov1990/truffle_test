var Migrations = artifacts.require("./Migrations.sol");
//
// var ERC20 = artifacts.require("./erc20.sol");
// var ERC2_NEW = artifacts.require("./erc20_new.sol");
// var Crowdsale = artifacts.require("./Crowdsale.sol");
// var MultiSigWallet = artifacts.require("./multiSigWallet.sol");
// var MigrationAgent = artifacts.require("./migrateAgent.sol");

module.exports = async deployer => {
    try {
        // await deployer.deploy(Migrations);
        console.log('------------- STEP 1');
        // await deployer.deploy(
        //     ERC20,
        //     "Token 1",
        //     "T1",
        //     "0x9d12f4d20efd2135ab5b50a26456dccfb6e15a3f",
        //     "0x33e0547fc6d1a1077226f0bf931c7e07ca91ac6e",
        //     "0x20d54aa08e2d9fe33ac35eff1c85665341cfe9a0",
        //     "0xa9806f5cefa0ffde5e75b51d16a9eed0908f7463"
        // );
        //
        // console.log('1-- ', ERC20.address);
        //
        // await deployer.deploy(
        //     MultiSigWallet
        // );
        //
        // console.log('2-- ', MultiSigWallet.address);
        //
        // await deployer.deploy(
        //     Crowdsale,
        //     MultiSigWallet.address,
        //     ERC20.address
        // );
        //
        // await deployer.deploy(
        //     MigrationAgent,
        //     ERC20.address
        // );
        //
        // await deployer.deploy(
        //     ERC2_NEW,
        //     "Token 2",
        //     "T2"
        // );

    } catch (error) {
      console.log(error);
    }
};
