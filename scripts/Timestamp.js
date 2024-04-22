const { Web3 } = require('web3'); //Import web3 library

//connection to Ganache
const web3 = new Web3('http://localhost:7545'); 

//contract addresses (i will update as deployed), with artifacts (ABI, bytecode, etc,.)
const TimestampDependentAddress = '0x08bf6f7536C076f626470236402A3c0Bf453Ec41';
const TimestampArtifact = require('../build/contracts/TimestampDependentContract.json');

//creating instances with the used of the ABIs
const TimestampContract = new web3.eth.Contract(TimestampArtifact.abi, TimestampDependentAddress);

async function main() {
    const [account] = await web3.eth.getAccounts(); //get accounts
    console.log('Setting deadline...');
    //new dealine calculation, and adding 10 seconds to ensure in future, whilst waiting for mined confirmation
    const setDeadlineTx = await TimestampContract.methods.setDeadline(Math.floor(Date.now() / 1000) + 10).send({ from: account }); 
    console.log('Deadline set successfully:', setDeadlineTx.transactionHash);

    const currentTimestamp = (await web3.eth.getBlock('latest')).timestamp; //gathering data on latest block
    console.log('Current timestamp:', currentTimestamp);
    const currentDeadline = await TimestampContract.methods.getDeadline().call(); //calling the current deadline
    console.log('Current deadline:', currentDeadline);

    console.log('Fast-forwarding blockchain time...');
    const targetTimestamp = await TimestampContract.methods.getDeadline().call(); //calling deadline
    const increaseTimeParams = [Number(targetTimestamp) - Number(currentTimestamp) + 1000]; //increasing time, fast forwarding time in blockchain
    await web3.currentProvider.request({
        method: 'evm_increaseTime', //method for fast forwarding time
        params: increaseTimeParams,
        id: new Date().getTime(), //new date
    });

    console.log('Blockchain time fast-forwarded to pass the deadline.');

    console.log('Calling the attack function after the deadline has passed...');
    const attackResult = await TimestampContract.methods.attack(60).send({ from: account }); //simulating attack function from attacking contract
    console.log('Attack result:', attackResult);

    const participants = await TimestampContract.methods.users(account).call(); //calling for display of accounts for usability
    console.log('Participants count for account:', participants);

    console.log('Depositing ether into the contract...');
    const depositAmount = web3.utils.toWei('1', 'ether'); //deposited 1 Ether
    await TimestampContract.methods.deposit().send({ from: account, value: depositAmount });
    console.log('Ether successfully deposited into the contract.');

    const contractBalance = await web3.eth.getBalance(TimestampDependentAddress); //getting new balance
    console.log('Contract balance:', web3.utils.fromWei(contractBalance, 'ether'), 'ETH');

    if (Number(contractBalance) > 0) {
        console.log('Withdrawing funds from the contract...');
        await TimestampContract.methods.withdraw().send({ from: account }); //withdrawing funds from TimestampContract
        console.log('Funds successfully withdrawn from the contract.');
    } else {
        console.log('No funds available to withdraw from the contract.');
    }
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
