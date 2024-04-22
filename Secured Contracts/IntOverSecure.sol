/* COMPILER VERSION OLDER THAN ONE BEING USED, TO BE TESTED VIA REMIX
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;

//SafeMath library import
import "@openzeppelin/contracts/math/SafeMath.sol";

contract SecuredIntegerOverflow {

    using SafeMath for uint256;
    mapping(address => uint256) public userBalances; //store user balances

    function deposit() public payable {
        userBalances[msg.sender] = userBalances[msg.sender].add(msg.value); //Securely adding deposited amount to user balance
    }

    function getBalance() public view returns (uint256) {
        return userBalances[msg.sender]; //return user balance
    }

    function multipleTransfers(address[] memory ETHreceivers, uint256 value) public payable returns (bool) { //taking multiple arguments for multile transfers
        require(ETHreceivers.length > 0 && ETHreceivers.length <= 10, "Limit of 10 receivers allowed"); //limiting amount of recievers 
        uint256 totalAmount = value.mul(ETHreceivers.length); //total amount transfer calculation
        require(value > 0 && userBalances[msg.sender] >= totalAmount, "Balance too low");

        userBalances[msg.sender] = userBalances[msg.sender].sub(totalAmount); //subtract from user balance securely

        for (uint256 i = 0; i < ETHreceivers.length; i++) {
            userBalances[ETHreceivers[i]] = userBalances[ETHreceivers[i]].add(value); //add amount to balance securely
        }
        return true;
    }
}
*/