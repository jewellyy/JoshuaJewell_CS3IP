README Document on Attack Simulation Process

Setup:
 Online: Open https://remix.ethereum.org/ and clone all smart contracts to test with following instructions.
    ... Connect to MetaMask account after setup --> https://metamask.io/
      ... Follow transactions on Etherscan --> https://etherscan.io/
 Local: Download Ganache from https://archive.trufflesuite.com/ganache/ 
   ... and install truffle with 'npm install -g truffle' in command prompt + 'npm install web3' for web3
     ... also ensure Node.js is installed (https://nodejs.org/en)
       ... Code editing recommended in VSCode (https://code.visualstudio.com/)

Online simulations: 

1. Re-entrancy/ Unchecked External Call:
Deploy the vulnerable contract, followed by the attacker contract with the initial address.
Account 1 deposits 5 Ether in to the bank contract.
Account 2 deposits 5 Ether in to the bank contract.
Account 3 calls the attack function with a 1 Ether deposit, which withdraws the full currency from the bank to the attackrs contract.
Account 3 calls the withdraw function to collect the currency in the attacker contract.

2. Integer Overflow: 
Account 1 deploys the contract and enters the following values in the corresponding fields in multipleTransfers:
ETHreceivers: ["0x64AD9596b8EF717Effe34341590909828FFc781c","0x217d1CB46a45C82537A96Dc02EB35548499d196A"]
   ... CHANGE FIRST ADDRESS WITH ACCOUNT 2 OF CURRENT SETUP
Value: 57896044618658097711785492504343953926634992332820282019728792003956564819968
Then, click transact.
Navigate to account 2 and call the getValue function, which will show the value above.

3. Timestamp Dependence:

-- This can only be simulated locally due to the time manipulation of current block --

4. Missing Access Control:
Account 1 deposits 5 Ether.
Account 2 withdraws the Ether on behalf of the other account by entering Account 1 address.

5. Weak Access Control:
Account 1 deposits 5 Ether.
Account 1 (assuming unauthorised access to account) switches ownership to Account 2.
Account 2 selects the withdrawOwner function, withdrawing all of the funds.

6. Front Running:
Set the manipulatePrice function to 1 ETH (1,000,000,000,000,000,000 wei).
Call the exploit function from the AttackingContract() with 2 ETH, which will manipulate the price to a value of 3 ETH, ensuring it is processed before any other users, instantly calling the purchase function, front-running other buyers.


7. DoS:
Use different accounts to set increasing values with the SetValue() function, which should successfully work.
Then, using any account, set a value higher than the current one using the attack() function, which will set the leader to the attack.sol contract address as the current leader.
Now, attempt to deposit a higher value again using the SetValue() function again, it will seem to work, but the leader address will remain as attack.sol contract, therefore making the function inaccessible, presenting a DoS attack.


8. Logic Error:
Deposit (enter) using 1 ETH from account 1.
Deposit (enter) using 1 ETH from account 2.
Deposit (enter) using 1 ETH from account 3.
Call attack function in attacking contract with account 3.
Check the accounts, the attacker will have selected the winner early, increasing their chances of winning.

9. Insecure Randomness:
Use the randomNumberGeneration function in the initial contract and then call the randomNumber function to see the generated value.
Simply then calling the attack function allows the attacker to change the number, they can also see the random number.

10. Gas Limit:
Deposit 1 ETH.
Attempt to withdraw 1000000000, and analyse the gas estimation error.


Local Simulations:
Simply deploy the contract desired to test on with 'truffle migrate --reset'.
Modify the correlating script to include the new contract address displayed in the deployment details.
run 'node ... .js'.
where ... type the script for the contract, e.g. node GasLimit.js (ensuring in the scripts directory).
