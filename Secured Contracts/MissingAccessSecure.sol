// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol"; 

contract NoAccessControlSecure is Ownable {

    mapping(address => uint256) private amount; //store amount deposited from addresses

    uint256 private maxWithdrawal = 5 ether;

    event EtherDeposited(address indexed depositor, uint256 amount); //emit when Ether deposited
    event EtherWithdrawn(address indexed recipient, uint256 amount); //emit when Ether withdrawn
    event WithdrawalLimitModification(uint256 newLimit); //emit when limit changed_

    constructor() Ownable(msg.sender) {} //setting owner

    modifier onlyAuthorized(address account) {
        require(msg.sender == owner() || msg.sender == account, "access is not authorised"); //only owner
        _;
    }

    function deposit() public payable onlyAuthorized(msg.sender) { //only owner can access
        amount[msg.sender] += msg.value; //increase amount when deposit
        emit EtherDeposited(msg.sender, msg.value); //emit deposit
    }

   function withdraw() public onlyAuthorized(msg.sender) {
        uint256 balance = amount[msg.sender]; //get the amount deposited
        require(balance > 0, "No ether deposited");
        require(balance <= maxWithdrawal, "Withdrawal amount exceeds limit");
        amount[msg.sender] = 0; //reset to 0
        payable(msg.sender).transfer(balance); //transferring to owner
        emit EtherWithdrawn(msg.sender, balance); //emit withdrawal
    }

    function setWithdrawalLimit(uint256 newLimit) public onlyOwner { //only accessed by owner
        maxWithdrawal = newLimit; //change withdraw limit
        emit WithdrawalLimitModification(newLimit); //emit change
    }

    function getBalance(address addr) public view returns (uint256) {
        return amount[addr]; //return amount deposited
    }
}