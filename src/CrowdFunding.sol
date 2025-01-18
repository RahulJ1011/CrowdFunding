// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract CrowdFunding{
    string public name;
    string public description;
    uint256 public goal;
    uint256 public deadline;
    address public owner;
    
    constructor(string memory _name, string memory _description,uint256 _goal,uint256 _durationIndays){
        name=_name;
        description=_description;
        goal = _goal;
        deadline = block.timestamp + (_durationIndays*1 days);
        owner = msg.sender;
    }
}