// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  mapping (address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 30 seconds;
  bool public openForWithdraw = false;

  modifier notCompleted() {
    require(!exampleExternalContract.completed(), "Contract already completed");
    _;
  }

  event Stake(address indexed from, uint256 amount);
  
  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )

  function stake () public payable {
    require(deadline > block.timestamp, "Staking period is over");
    console.log("Staking %s", msg.value);
    balances[msg.sender] += msg.value; // add the amount staked to the sender's balance
    if (address(this).balance < threshold) {  
      openForWithdraw = true;
    } else {
      openForWithdraw = false;
    }
    emit Stake(msg.sender, msg.value);
  }

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`

  function execute () public notCompleted {
    require(block.timestamp >= deadline, "Deadline is not reached");
    require(address(this).balance >= threshold, "Threshold is not reached");
    balances[msg.sender] = 0; // reset the sender's balance
    exampleExternalContract.complete{value: address(this).balance}();
    console.log("Contract balance: %s", address(this).balance);
    openForWithdraw = false;
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
  function withdraw () public notCompleted {
    require(openForWithdraw, "Withdraw is not open");
    uint256 amount = balances[msg.sender];
    balances[msg.sender] = 0;
    payable(msg.sender).transfer(amount);
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256) {
    
    if (block.timestamp >= deadline) {
      console.log("Deadline is reached");
      return 0;
    } else {
      console.log("Time left: %s", deadline - block.timestamp);
      return deadline - block.timestamp;
    }
  }

  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable {
    stake();
  }

}
