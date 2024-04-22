// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract InsecureRandomness {

    uint256 public randomNumber; //for storage of generated number
    function randomNumberGeneration() public { 
        uint256 blockNumber = block.number - 1; //retain previous block number
        uint256 blockHash = uint256(blockhash(blockNumber)); //retains previous block hash
        randomNumber = blockHash % 100; //genrate random integer with block hash modulus (100)
    }
}

contract RandomnessAttack {

    InsecureRandomness public vulnerableContract; 
    constructor(InsecureRandomness _vulnerableContract) { //uses vulnerable address for attack
        vulnerableContract = _vulnerableContract;
    }

    function attack() public {
        vulnerableContract.randomNumberGeneration(); //calling randomNumberGeneration function
    }

    function getRandomNumber() public view returns (uint256) {
        return vulnerableContract.randomNumber(); //return random number
    }
}