// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol"; //ownable for access control
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"; //re-entracy guard for extra security

contract WeakAccessControlSecure is Ownable, ReentrancyGuard {

    mapping(address => uint256) private amount; //store user balances

    event EtherDeposited(address indexed depositor, uint256 amount); //emit when deposited
    event OwnerSwitched(address indexed previousOwner, address indexed newOwner); //emit when owner switched

    constructor() Ownable(msg.sender) {} //initialise owner

    modifier onlyIfBalanceGreaterThanZero() {
        require(address(this).balance > 0, "Contract balance is zero");
        _;
    }

    modifier validNewOwner(address _newOwner) {
        require(_newOwner != address(0), "Invalid new owner address");
        _;
    }

    function deposit() public payable {
        amount[msg.sender] += msg.value; //amount update upon deposit
        emit EtherDeposited(msg.sender, msg.value); //emit deposit
    }

    function withdraw(uint256 sum) public nonReentrant {
        require(amount[msg.sender] >= sum, "Insufficient balance");
        amount[msg.sender] -= sum; //deduct sum when withdrawn
        payable(msg.sender).transfer(sum);
    }

    function switchOwner(address payable _newOwner) public onlyOwner validNewOwner(_newOwner) nonReentrant { //new owner switch variables
        address previousOwner = owner();
        transferOwnership(_newOwner); //transferring the ownership to provided address
        emit OwnerSwitched(previousOwner, _newOwner); //emit new owner
    }

    function withdrawOwner() public onlyOwner onlyIfBalanceGreaterThanZero nonReentrant {
        uint256 balance = address(this).balance; //withdraw funds to current owner
        payable(owner()).transfer(balance);
    }
}