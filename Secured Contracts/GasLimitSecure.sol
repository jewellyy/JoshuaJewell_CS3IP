// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract GasLimitVulnerability {
    mapping(address => uint256) public balances; //store user balances
    function deposit() public payable {
        balances[msg.sender] += msg.value; //increase when deposited to amount sent
    }
    
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Caller address is too low");
        require(address(this).balance >= amount, "Contract balance is too low");
        (bool success, ) = payable(msg.sender).call{value: amount}(""); //calling amount
        require(success, "Error whilst transferring funds");
        balances[msg.sender] -= amount;
    }
}