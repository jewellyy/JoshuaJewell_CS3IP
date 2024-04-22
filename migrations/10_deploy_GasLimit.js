const GasLimit = artifacts.require('GasLimitVulnerability'); //getting artifacts (ABI, bytecode, etc,.)
module.exports = async function(deployer) {
  await deployer.deploy(GasLimit); //deploy the contract
};
