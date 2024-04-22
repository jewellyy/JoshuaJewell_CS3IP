const { Web3 } = require('web3'); //Import web3 library

//connection to Ganache
const web3 = new Web3('http://localhost:7545'); 

//contract address (I will update after each deployment)
const NoAccessControlAddress = '0xb8EC11f5489C5064854a91b2E206a6afF9CD56Ce';

//getting artifact (ABI, bytecode, etc,.)
const NoAccessControlArtifact = require('../build/contracts/NoAccessControl.json');
//const NoAccessControlSecureArtifact = require('../build/contracts/NoAccessControlSecure.json');

//creating instances with the used of the ABIs
const NoAccessControlContract = new web3.eth.Contract(NoAccessControlArtifact.abi, NoAccessControlAddress);
//const NoAccessControlContract = new web3.eth.Contract(NoAccessControlSecureArtifact.abi, NoAccessControlAddress);

//Alternative approach
const account1 = '0x654f54f80eabbDa4A08F3F30d7355dEA149E4d44'; //address of account 1
const account2 = '0x9bF6D83C8DA80ce1430fB78579Bf386Baa570188'; //address of account 2
const amountToDeposit = web3.utils.toWei('3', 'ether'); //deposit 3 Ether

async function executeTransaction() {
    console.log('Depositing 3 ether from account1');
    await NoAccessControlContract.methods.deposit().send({ //depositin 3 ETH from account 1
        from: account1,
        value: amountToDeposit
    });
    console.log(`Deposited 3 ether from account1`);

    console.log(`Withdrawing 3 ether to account1 from account2`);
    await NoAccessControlContract.methods.withdraw(account1).send({ //withdrawing the funds with account 2
        from: account2
    });
    console.log(`Withdrawn 3 ether to account1 from account2`);
}
executeTransaction().catch(console.error);