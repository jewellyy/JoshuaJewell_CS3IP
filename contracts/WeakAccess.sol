// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

contract WeakAccessControl {

    address owner; //storing owner address
    mapping(address => uint256) public amount; //store balances or all users
    constructor() {
        owner = msg.sender; //owner initialisation 
    }

    function deposit() public payable {
        amount[msg.sender] += msg.value; //Balance increased by the amount deposited
    }

    function withdraw(uint256 sum) public {
        require(amount[msg.sender] >= sum, "balance too low"); //checks for balance too low against requirements
        amount[msg.sender] -= sum; //decrease balance when withdrawn
        payable(msg.sender).transfer(sum); //transfer to sender
    }

    function switchOwner(address payable owner2) public {
        require(msg.sender == owner, "function only available to current owner"); //ensures sender is owner
        owner = owner2; //transferring to new owner
    }

    function withdrawOwner() public {
        require(msg.sender == owner, "function only available to current owner"); //must be owner
        uint256 balance = address(this).balance; //balance checking
        require(balance > 0, "0 ETH"); //more than 0
        payable(owner).transfer(balance); //transfer the sum to new/ current owner
    }
}