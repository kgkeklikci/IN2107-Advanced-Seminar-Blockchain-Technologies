// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AccessRestriction {

  // declare state variables
  address owner;
  uint timestamp;
  string instance;

  // define custom events
  event ownerChange(address _owner, address buyer, uint _timestamp);
  event gasUsage(uint _gas);

  // constructor 
  constructor() {
    owner = msg.sender;
    timestamp = block.timestamp;
    instance = "Access Restriction Pattern";
  }

  // implement getter for owner test
  function getOwner() public view returns(address) {
    return owner;
  }

  // implement getter for instance test
  function getInstance() public view returns(string memory) {
    return instance;
  }

  // implement access restriction to change the owner
  modifier onlyOwner(address account) {
    require(msg.sender == account, "Unauthorized access!");
    // execute rest
    _;
  }

  // implement requirement to purchase
  modifier contractCost(uint cost) {
    require(cost <= msg.value, "Insufficient balance!");
    _;
    if(msg.value > cost) {
      uint current_gas = gasleft();
      payable(msg.sender).transfer(msg.value - cost);
      // demonstrate 2300 gas unit decrease in a `transfer` call
      emit gasUsage(gasleft() - current_gas);
    }
  }

  // implement requirement to disown the contract
  modifier onlyAfter(uint _time) {
    require(block.timestamp >= _time, "Cannot disown contract yet!");
    _;
  }

  // disown the contract
  function disown() public onlyOwner(owner) onlyAfter(timestamp + 4 weeks) {
    delete owner;
  }

  // change the owner
  function changeOwner(address _owner) public onlyOwner(owner) {
    timestamp = block.timestamp;
    emit ownerChange(owner, _owner, block.timestamp);
    owner = _owner;
  }

  // use `external` in case function is not called by the contract itself
  // due to gas efficiency
  function forceOwnerChange(address _owner) public payable contractCost(100 gwei) {
    owner = _owner;
  }
}
