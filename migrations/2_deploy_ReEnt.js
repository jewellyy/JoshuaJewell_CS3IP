const MyContract = artifacts.require('MyContract'); //getting artifacts (ABI, bytecode, etc,.)
//const MyContractSecure = artifacts.require('MyContractSecure'); 
const MyAttacker = artifacts.require('MyAttacker');

module.exports = async function(deployer) {
  await deployer.deploy(MyContract);
  //await deployer.deploy(MyContractSecure);
  const myContractInstance = await MyContract.deployed(); //deploy this contract after the other so it can take the address as an argument
  //const myContractInstance = await MyContractSecure.deployed();

  await deployer.deploy(MyAttacker, myContractInstance.address); //deploy the contracts
};

module.exports.tags = ['MyContract', 'MyAttacker']; // use this when testing attack! //tags to run based on names
//module.exports.tags = ['MyContractSecure', 'MyAttacker']; 