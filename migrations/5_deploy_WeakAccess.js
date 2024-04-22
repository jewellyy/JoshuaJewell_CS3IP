const WeakAccessControl = artifacts.require('WeakAccessControl'); //getting artifacts (ABI, bytecode, etc,.)
//const WeakAccessControlSecure = artifacts.require('WeakAccessControlSecure'); 

module.exports = async function(deployer) {
  await deployer.deploy(WeakAccessControl); //deploy the contract
  //await deployer.deploy(WeakAccessControlSecure); 
};