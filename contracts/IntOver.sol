/*
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0; //older compiler version to one used, i either downgrade or test with remix

contract IntegerOverflow {

    mapping (address=>uint) userBalances; //mapping for balance storage
        
    function deposit() public payable{ 
    userBalances[msg.sender] = msg.value; //set balance based on sent value

    }
        function getBalance() public view returns (uint){
            return userBalances[msg.sender]; //returns the current account balance
    }

    function multipleTransfers(address[] memory ETHreceivers, uint256 value) public payable returns (bool) {
     require(ETHreceivers.length > 0 && ETHreceivers.length <= 11, "Limit of 10 recievers allowed"); //between 1 and 10
     uint256 sum = value * ETHreceivers.length; //transfer amount sum
     require(value > 0 && userBalances[msg.sender] >= sum, "Balance too low"); //checking if balance is enough
     userBalances[msg.sender] -= sum; //decrease balance by amount transferred
     for (uint256 i = 0; i < ETHreceivers.length; i++) { //looping through recievers
        userBalances[ETHreceivers[i]] += value; //add value to each
    }
    return true;
  }
}
*/