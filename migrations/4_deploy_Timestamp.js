const TimestampDependentContract = artifacts.require('TimestampDependentContract'); //getting artifacts (ABI, bytecode, etc,.)

module.exports = async function(deployer) {
  await deployer.deploy(TimestampDependentContract); //deploy the contract
};