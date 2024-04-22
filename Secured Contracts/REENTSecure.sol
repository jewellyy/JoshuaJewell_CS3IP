// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"; //import guard for re-entrancy attacks 

contract MyContractSecure is ReentrancyGuard {

    mapping(address => uint256) private userBalances; //store user balances

    function deposit() public payable nonReentrant {
        require(msg.sender != address(0), "Sender address is not acceptable");
        require(msg.value > 0, "Amount must be deposited");
        userBalances[msg.sender] += msg.value; //increase balance of caller
    }

    function withdraw() public nonReentrant {
        require(msg.sender != address(0), "Sender address is not acceptable");
        uint256 balance = userBalances[msg.sender]; //get the callers balance
        require(balance > 0, "User trying to withdraw more than deposited");
        userBalances[msg.sender] = 0; //reset to 0
        (bool sent, ) = payable(msg.sender).call{value: balance}(""); //transferring to user
        require(sent, "Send Unsuccessful");
    }

    receive() external payable {
        revert("Do not send Ether directly to the contract");
    }

    fallback() external payable {
        revert("Do not call the fallback function directly");
    }
}