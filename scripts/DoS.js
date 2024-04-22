const { Web3 } = require('web3'); //Import web3 library

//connection to Ganache
const web3 = new Web3('http://localhost:7545'); 

//getting artifacts (ABI, bytecode, etc,.)
const LeaderArtifact = require('../build/contracts/VotingLeader.json');
const AttackArtifact = require('../build/contracts/Attack.json');

//contract addresses (I will update after each deployment)
const LeaderAddress = '0x27e14b00a0e369F4Fb2e034aB958a1662940e30B';  
const AttackAddress = '0x199e374d680f6be7F0255838b05786f1561c5c65';

//creating instances with the used of the ABIs
const LeaderContract = new web3.eth.Contract(LeaderArtifact.abi, LeaderAddress);
const AttackContract = new web3.eth.Contract(AttackArtifact.abi, AttackAddress);

async function setValue(accountIndex, value) {
  const accounts = await web3.eth.getAccounts(); //getting accounts provided in Ganache 
  const sender = accounts[accountIndex]; //selecting the sender from the array - account based on idex provided, if none, account 0
  const gasPrice = await web3.eth.getGasPrice(); //gas price retreival of Ganache
  //Transaction automation
  const transaction = {
    from: sender,
    to: LeaderAddress,
    gas: 200000,
    gasPrice: gasPrice,
    data: LeaderContract.methods.setValue().encodeABI(),
    value: value,
  };
  try {
    await web3.eth.sendTransaction(transaction);
    console.log(`Account ${accountIndex + 1} set value to ${value}.`);
  } catch (error) {
    console.error(`Account ${accountIndex + 1} failed. Error: ${error.message}`);
  }
}
//Attack automation
async function attack() {
  const accounts = await web3.eth.getAccounts();
  const attacker = accounts[accounts.length - 1]; 
  const gasPrice = await web3.eth.getGasPrice();
  const transaction = {
    from: attacker,
    to: AttackAddress,
    gas: 200000,
    gasPrice: gasPrice,
    data: AttackContract.methods.attack().encodeABI(),
    value: web3.utils.toWei('8', 'ether'), 
  };
  try {
    await web3.eth.sendTransaction(transaction);
    console.log(`Attack executed successfully.`);
  } catch (error) {
    console.error(`Attack failure. Error: ${error.message}`);
  }
}
//Transaction attempt after attack simulated (i will expect an error)
async function postAttackAttempt(accountIndex, value) {
  const accounts = await web3.eth.getAccounts();
  const sender = accounts[accountIndex];
  const gasPrice = await web3.eth.getGasPrice();
  const transaction = {
    from: sender,
    to: LeaderAddress,
    gas: 200000,
    gasPrice: gasPrice,
    data: LeaderContract.methods.setValue().encodeABI(),
    value: value,
  };
  try {
    await web3.eth.sendTransaction(transaction);
    console.log(`Account ${accountIndex + 1} attempted to set value after the attack.`);
  } catch (error) {
    console.error(`Account ${accountIndex + 1} failed to set value after the attack. Error: ${error.message}`);
  }
}
//delay setting for a more user-friendly simulation, easier to understand
setValue(0, web3.utils.toWei('1', 'ether'));
setTimeout(() => setValue(1, web3.utils.toWei('2', 'ether')), 2000);  
setTimeout(() => setValue(2, web3.utils.toWei('3', 'ether')), 4000); 
setTimeout(() => attack(), 6000);  
setTimeout(() => postAttackAttempt(1, web3.utils.toWei('4', 'ether')), 8000);