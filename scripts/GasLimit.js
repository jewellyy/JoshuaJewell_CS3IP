const { Web3 } = require('web3'); //Import web3 library

//connection to Ganache
const web3 = new Web3('http://localhost:7545'); 

//contract address (I will update after each deployment)
const GasLimitAddress = '0x75e9c104AFaDf25fB494c011230Fe168673E16e9';

//getting artifacts (ABI, bytecode, etc,.)
const GasLimitArtifact = require('../build/contracts/GasLimitVulnerability.json');

//creating instances with the used of the ABIs
const GasLimitContract = new web3.eth.Contract(GasLimitArtifact.abi, GasLimitAddress);

//attack simulation function
async function simulateGasLimit() {
  const GanacheAccounts = await web3.eth.getAccounts(); //get accounts
  await GasLimitContract.methods.deposit().send({ //deposit 5 Ether
    from: GanacheAccounts[0],
    value: web3.utils.toWei('5', 'ether')
  });
  console.log("Deposited 5 ether from Ganache account");
  try {
    await GasLimitContract.methods.withdraw('1000000000').send({ //out of gas here due to large amount with loop iterations
      from: GanacheAccounts[0]
    });
    console.log("Withdraw successful");
  } catch (error) {
    console.log("Error:", error.message);
  }
}
simulateGasLimit();