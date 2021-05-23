const Migrations = artifacts.require("Migrations");

module.exports = function(deployer, matic, accounts) {
  console.log(`Using network: matic`);
  console.log('Using matic', matic);
  deployer.deploy(Migrations);
};
