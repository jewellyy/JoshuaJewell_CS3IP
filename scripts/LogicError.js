const { Web3 } = require('web3'); //Import web3 library

//connection to Ganache
const web3 = new Web3('http://localhost:7545'); 

//getting artifacts (ABI, bytecode, etc,.)
const LogicErrorArtifact = require('../build/contracts/LogicError.json');
const LogicAttackerArtifact = require('../build/contracts/LogicAttacker.json');

//contract addresses (I will update after each deployment)
const LogicErrorAddress = '0xCE3AFF4EC93352D1885B89f17a434Ed41ebe9EB4';
const LogicAttackerAddress = '0x19D1Bf5AA3c51319c6a9eE0B8386EEc43F9CB553';

//creating instances with the used of the ABIs
const logicErrorContract = new web3.eth.Contract(LogicErrorArtifact.abi, LogicErrorAddress);
const logicAttackerContract = new web3.eth.Contract(LogicAttackerArtifact.abi, LogicAttackerAddress);

//Different approach taken for variety, code inside try catch block
async function simulateAttack() {
    try {
      const accounts = await web3.eth.getAccounts(); //get accounts
      await logicErrorContract.methods.enterGame().send({ from: accounts[0], value: web3.utils.toWei("1", "ether") }); //enter game with 1 Ether from account 1
      console.log("Deposit from account 0 successful.");

      await logicErrorContract.methods.enterGame().send({ from: accounts[1], value: web3.utils.toWei("1", "ether") }); //enter game with 1 Ether from account 2
      console.log("Deposit from account 1 successful.");

      await logicErrorContract.methods.enterGame().send({ from: accounts[2], value: web3.utils.toWei("1", "ether") }); //enter game with 1 Ether from account 3
      console.log("Deposit from account 2 successful.");

      console.log("Attack in progress...");
      await logicAttackerContract.methods.attack().send({ from: accounts[2], value: web3.utils.toWei("1", "ether"), gas: 5000000 }); //attack with account 3
      console.log("Attack completed.");
      
    } catch (error) {
      console.error("Error during attack:", error);
    }
  }
  simulateAttack();