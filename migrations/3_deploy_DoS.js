//please deploy vulnerable and secure seperately
const VotingLeader = artifacts.require('VotingLeader'); //getting artifacts (ABI, bytecode, etc,.)
const Attack = artifacts.require('Attack');

module.exports = async function(deployer) {
  await deployer.deploy(VotingLeader);
  const VotingLeaderInstance = await VotingLeader.deployed(); //deploy this contract after the other so it can take the address as an argument

  await deployer.deploy(Attack, VotingLeaderInstance.address); //deploy the contracts
};

module.exports.tags = ['VotingLeader', 'Attack']; //tags to run based on names