const Migrations = artifacts.require('./Migrations.sol');
const ChiToken = artifacts.require('./ChiToken.sol');

module.exports = function (deployer) {
    deployer.deploy(Migrations);
    deployer.deploy(
        ChiToken
    );
};
