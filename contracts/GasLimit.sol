// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract GasLimitVulnerability {

    mapping(address => uint256) public balances; //mapping to stora address balances
    function deposit() public payable { //payable so Eth can be deposited
        balances[msg.sender] += msg.value; //Increase sender balance based on amount sent 
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Balance too low"); //checking user balance, if too low, produce error
        for (uint256 i = 0; i < amount; i++) { //loop for amount requested
            (bool success, ) = msg.sender.call{value: 1 wei}(""); //1 wei for each iteration
            require(success, "Transfer unsuccessful");
        }
        balances[msg.sender] -= amount; //decrease balance of sender amount
    }
}