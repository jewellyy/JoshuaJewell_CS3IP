// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract VotingLeader {

    address payable public Leader; //current leader address
    uint public PriceValue; //current price
    uint256 public constant MinimumGas = 10000;
    uint256 public constant MaxValue = 100e18;
    uint256 public constant cooldown = 1 minutes; //transaction cooldown

    mapping(address => uint256) private lastTransactionTime; //tracking time of last transaction
    modifier onlyAccounts() {
        require(!Contract(msg.sender), "Leader must be an account, not a contract");
        _;
    }

    event LeaderChanged(address indexed newLeader);

    constructor() {
        Leader = payable(msg.sender); //setting deployer as leader
    }

    function setValue() public payable onlyAccounts {
        require(gasleft() > MinimumGas, "Invalid gas sum");
        require(msg.value > PriceValue && msg.value <= MaxValue, "Invalid value");
        require(transactionPossible(msg.sender), "rate is limited");
        uint256 remainingGas = gasleft(); //retrieve the remaining gas
        PriceValue = msg.value; //update value
        Leader = payable(msg.sender); //update leader
        emit LeaderChanged(Leader); //emit new leader

        //Transfer ammount to leader with remaining gas
        (bool success, ) = Leader.call{value: PriceValue, gas: remainingGas}("");
        require(success, "Transfer failed");
    }

    function Contract(address account) internal view returns (bool) { //check if address is a contract
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function transactionPossible(address user) private view returns (bool) {
        if (lastTransactionTime[user] + cooldown < block.number) { //check if transaction is allowed based on cooldown period
            return true;
        }
        return false;
    }
}

contract Attack {
    VotingLeader votingleader;
    constructor(address _votingleader) {
        votingleader = VotingLeader(_votingleader); //Initialising variable with vulnerable contract
    }
    function attack() public payable {
        votingleader.setValue{value: msg.value}(); //calling the value set and sending Ether recieved
    }
}