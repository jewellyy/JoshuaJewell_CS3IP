const NoAccessControl = artifacts.require('NoAccessControl'); //getting artifacts (ABI, bytecode, etc,.)
//const NoAccessControlSecure = artifacts.require('NoAccessControlSecure'); 

module.exports = async function(deployer) {
  await deployer.deploy(NoAccessControl); //deploy the contract
  //await deployer.deploy(NoAccessControlSecure); 
};