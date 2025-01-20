// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract CrowdFunding{
    string public name;
    string public description;
    uint256 public goal;
    uint256 public deadline;
    address public owner;
    enum CampaignState {
        Active,Successfull,Failed
    }

    struct Tier{

        string name;
        uint256 amount;
        uint256 backers;
        
    }

    Tier[] public tier ;

    modifier onlyOwner()
    {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;

    }
     
    constructor(string memory _name, string memory _description,uint256 _goal,uint256 _durationIndays){
        name=_name;
        description=_description;
        goal = _goal;
        deadline = block.timestamp + (_durationIndays*1 days);
        owner = msg.sender;
    }

    function fund(uint256 _tierIndex) public payable{
       
        require(block.timestamp < deadline,"Fundraising period has ended");
        require(_tierIndex < tier.length," Invalid tier");
        require(msg.value == tier[_tierIndex].amount,"Incorrect amount");
        tier[_tierIndex].backers++;
       
    }

    function addTier(string memory _name,
        uint256 _amount) public onlyOwner{
            
            require(_amount>0 ,"Amount must be greater than 0" );
            tier.push(Tier(_name,_amount,0));
    }

    function removeTier(uint256 _index) public onlyOwner
    {
        require(_index < tier.length, "Tier does mot exist");
        tier[_index] = tier[tier.length-1];
        tier.pop();
    }

    function withdraw() public onlyOwner{
       
        require(address(this).balance >= goal,"Goal had not been reach");
        
        uint256 balance = address(this).balance;
        require(balance > 0,"No balance to withdraw");

        payable(owner).transfer(balance);
    }

    function getContractBalance() public view returns(uint256) {

        return address(this).balance;   
    }

}
