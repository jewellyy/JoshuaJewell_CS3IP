const InsecureRandomnessContract = artifacts.require("InsecureRandomness"); //getting artifacts (ABI, bytecode, etc,.)
const RandomnessAttackContract = artifacts.require("RandomnessAttack"); //getting artifacts (ABI, bytecode, etc,.)

module.exports = async function (deployer) {
  await deployer.deploy(InsecureRandomnessContract);
  const deployedInsecureRandomnessContract = await InsecureRandomnessContract.deployed(); //deploy this contract after the other so it can take the address as an argument
  await deployer.deploy(RandomnessAttackContract, deployedInsecureRandomnessContract.address); //deploy the contracts
};