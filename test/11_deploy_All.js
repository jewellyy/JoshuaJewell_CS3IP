//THIS IS FOR A CONDENSED VISUAL REPRESENTATION IN REPORT, DO NOT USE! PLEASE DEPLOY SEPERATELY AS TESTING
const MyContractSecure = artifacts.require('MyContractSecure');
const MyAttacker = artifacts.require('MyAttacker');
const VotingLeader = artifacts.require('VotingLeader');
const Attack = artifacts.require('Attack');
const TimestampDependentContract = artifacts.require('TimestampDependentContract');
const WeakAccessControlSecure = artifacts.require('WeakAccessControlSecure');
const NoAccessControlSecure = artifacts.require('NoAccessControlSecure');
const FrontRunningContract = artifacts.require('FrontRunningContract');
const AttackingContract = artifacts.require('AttackingContract');
const LogicErrorContract = artifacts.require('LogicError');
const LogicAttackerContract = artifacts.require('LogicAttacker');
const InsecureRandomnessContract = artifacts.require('InsecureRandomness');
const RandomnessAttackContract = artifacts.require('RandomnessAttack');
const GasLimit = artifacts.require('GasLimitVulnerability');

module.exports = async function(deployer) {
    // Uncomment the following lines if needed
    // await deployer.deploy(MyContractSecure);
    // await deployer.deploy(WeakAccessControlSecure);
    // await deployer.deploy(NoAccessControlSecure);
    // await deployer.deploy(FrontRunningContract);
    // await deployer.deploy(LogicErrorContract);
    // await deployer.deploy(InsecureRandomnessContract);
    // await deployer.deploy(GasLimit);

    // Deploy contracts requiring deployment
    await deployer.deploy(MyContractSecure);
    const myContractInstance = await MyContractSecure.deployed();
    await deployer.deploy(MyAttacker, myContractInstance.address);

    await deployer.deploy(VotingLeader);
    const VotingLeaderInstance = await VotingLeader.deployed();
    await deployer.deploy(Attack, VotingLeaderInstance.address);

    await deployer.deploy(TimestampDependentContract);

    await deployer.deploy(WeakAccessControlSecure);

    await deployer.deploy(NoAccessControlSecure);

    await deployer.deploy(FrontRunningContract);
    const deployedFrontRunningContract = await FrontRunningContract.deployed();
    await deployer.deploy(AttackingContract, deployedFrontRunningContract.address);

    await deployer.deploy(LogicErrorContract);
    const deployedLogicErrorContract = await LogicErrorContract.deployed();
    await deployer.deploy(LogicAttackerContract, deployedLogicErrorContract.address);

    await deployer.deploy(InsecureRandomnessContract);
    const deployedInsecureRandomnessContract = await InsecureRandomnessContract.deployed();
    await deployer.deploy(RandomnessAttackContract, deployedInsecureRandomnessContract.address);

    await deployer.deploy(GasLimit);
};
