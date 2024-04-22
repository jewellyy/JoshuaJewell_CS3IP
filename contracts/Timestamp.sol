// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract TimestampDependentContract {

    address public owner; //public variable for owner address
    uint public deadline; //public variable for dealine set
    uint public constant MinimumDelay = 10; //comstant var for minimum delay
    mapping(address => uint) public users; //user mapping

    constructor() {
        owner = msg.sender; //owner initialised with the user that deployed the contract
        deadline = block.timestamp + MinimumDelay; //initial deadline
    }

    modifier OwnerFunction() {
        require(msg.sender == owner, "Owner permission only.");
        _;
    }

    function setDeadline(uint deadline2) public OwnerFunction {
        deadline = deadline2; //deadline to be set by owner
    }

function attack(uint sseconds) public {
    require(block.timestamp >= deadline || block.timestamp < deadline - sseconds, "Attack is not possible at the moment");
    //current deadline must be before or after the current block time subtracting number of seconds specified by user
    users[msg.sender] += 1; //gets value stored in users balance, and increments, tracking amount of times performed
}

    function withdraw() public OwnerFunction {
        uint amountToWithdraw = address(this).balance; //get user balance
        require(amountToWithdraw > 0, "Balance is 0, withdrawal impossible.");
        payable(owner).transfer(amountToWithdraw); //Current amount transferred to owner
    }

    function getDeadline() public view returns (uint) {
        return deadline; //get current deadline
    }

    function deposit() public payable { //deposit function
    }
}