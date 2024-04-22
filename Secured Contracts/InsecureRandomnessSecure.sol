// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract InsecureRandomness {
    uint256 public randomNumber;
    uint256 public lastBlockNumber;
    uint256 public lastBlockHash;
    address public owner;
    constructor() {
        owner = msg.sender; //initialise owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function randomNumberGeneration() public onlyOwner {
        require(block.number > lastBlockNumber, "Wait for new block"); //making sure a new block has been mined
        lastBlockNumber = block.number; //updating the final block number
        lastBlockHash = uint256(blockhash(block.number - 1)); //retrieve hash from final block
        randomNumber = secureRandomNumber(); //secure number generation
    }

    function secureRandomNumber() internal view returns (uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(lastBlockHash, block.timestamp))); //link hash and timestamp as seed
        return seed % (2**256 - 1); 
    }

    function getRandomNumberInternal() internal view onlyOwner returns (uint256) {
        return randomNumber;
    }

    function getRandomNumber() public onlyOwner view returns (uint256) {
        return getRandomNumberInternal();
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