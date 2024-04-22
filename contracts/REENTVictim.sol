//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;
contract MyContract {
    mapping (address => uint256) userBalances; //mapping for balances of users
    function deposit() public payable {
        require(msg.value > 0, "Must Deposit An Ethereum Amount"); //greater than 0
        userBalances[msg.sender] += msg.value; //add deposited amount to balance
    }
    function withdraw() public {
        uint256 balance = userBalances[msg.sender]; //rerieve balance
        require(balance > 0, "User trying to withdraw more than deposited"); //greater than 0

        (bool sent, ) = msg.sender.call{value: balance}(""); //send the users current balance
        require(sent, "Send Unsuccessful");
        userBalances[msg.sender] = 0; //balace back to 0 after withdrawn
    }
}