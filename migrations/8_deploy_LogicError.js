const LogicErrorContract = artifacts.require("LogicError"); //getting artifacts (ABI, bytecode, etc,.)
const LogicAttackerContract = artifacts.require("LogicAttacker"); //getting artifacts (ABI, bytecode, etc,.)

module.exports = async function (deployer) {
  await deployer.deploy(LogicErrorContract);
  const deployedLogicErrorContract = await LogicErrorContract.deployed(); //deploy this contract after the other so it can take the address as an argument
  await deployer.deploy(LogicAttackerContract, deployedLogicErrorContract.address); //deploy the contracts
};
