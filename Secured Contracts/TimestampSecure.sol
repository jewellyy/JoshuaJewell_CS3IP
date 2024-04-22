// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

// import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBase.sol";

contract TimestampDependentContract {
    address public owner;
    uint public deadline;
    uint public constant MinimumDelay = 10; //delay in blocks

    mapping(address => uint) public users; //user action tracking

    bool public deadlinePassed = false;
    //chainlink usage
    // bytes32 internal keyHash;
    // uint256 internal fee;

    constructor() {
        owner = msg.sender;
        deadline = block.number + MinimumDelay; //initial deadline submission

        //chainlink usage
        // keyHash = _keyHash;
        // fee = fee2;
    }

    modifier OwnerFunction() {
        require(msg.sender == owner, "Owner permission only.");
        _;
    }

    function setDeadline(uint deadline2) public OwnerFunction {
        require(!deadlinePassed, "Deadline passed.");
        require(deadline2 >= block.number + MinimumDelay, "New deadline must be at least MinimumDelay seconds in the future.");
        deadline = deadline2; //deadline being updated
    }

    function attack(uint sseconds) public {
        require(block.number >= deadline || block.number < deadline - sseconds, "Attack is not possible at the moment");
        users[msg.sender] += 1; //keeping action of attack
    }

    function withdraw() public OwnerFunction {
        require(!deadlinePassed, "Deadline passed.");
        uint amountToWithdraw = address(this).balance; //get current balance of contract
        require(amountToWithdraw > 0, "Balance is 0, withdrawal impossible.");
        payable(owner).transfer(amountToWithdraw); //transfer to owner
    }

    function getDeadline() public view returns (uint) {
        return deadline;
    }

    function deposit() public payable {
    }

    function passDeadline() public OwnerFunction {
        require(!deadlinePassed, "Deadline has already passed.");
        deadlinePassed = true;
    }
}
