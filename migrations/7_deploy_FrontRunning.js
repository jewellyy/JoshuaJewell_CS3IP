const FrontRunningContract = artifacts.require("FrontRunningContract"); //getting artifacts (ABI, bytecode, etc,.)
const AttackingContract = artifacts.require("AttackingContract"); //getting artifacts (ABI, bytecode, etc,.)

module.exports = async function (deployer) {
  await deployer.deploy(FrontRunningContract);
  const deployedFrontRunningContract = await FrontRunningContract.deployed(); //deploy this contract after the other so it can take the address as an argument
  await deployer.deploy(AttackingContract, deployedFrontRunningContract.address); //deploy the contracts
};
