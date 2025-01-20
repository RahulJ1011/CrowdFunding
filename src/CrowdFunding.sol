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

    function fund() public payable{
        require(msg.value > 0,"Must fund amount greater than 0");
        require(block.timestamp < deadline,"Fundraising period has ended");
        require(msg.sender != owner,"Owner cannot fund");
        // Add the amount to the total amount funded
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw ");
        require(address(this).balance >= goal,"Goal had not been reach");
        
        uint256 balance = address(this).balance;
        require(balance > 0,"No balance to withdraw");

        payable(owner).transfer(balance);
    }

    function getContractBalance() public view returns(uint256) {

        return address(this).balance;   
    }

}
