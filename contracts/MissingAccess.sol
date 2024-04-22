// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract NoAccessControl {
    mapping(address => uint256) public amount; //store deposited amounts

    function deposit() public payable {
        amount[msg.sender] += msg.value; //add funds deposited to user balance
    }

    function withdraw(address addr) public {
        uint256 balance = amount[addr]; //get balance of address intended
        require(balance > 0, "no ether deposited"); //need to deposit some Ether
        amount[addr] = 0; //set balance to 0
        payable(addr).transfer(balance); //transfer balance to adress deposited
    }
}