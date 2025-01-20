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
    CampaignState public state;
    struct Tier{

        string name;
        uint256 amount;
        uint256 backers;
    }

    struct Backer{
      
        uint256 totalContribution;
        mapping(uint256 => bool)fundedTiers;
    }

    Tier[] public tier ;
    mapping(address => Backer) public backers;

    modifier onlyOwner()
    {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;

    }
    modifier campaignOpen()
    {
        require(state == CampaignState.Active, "The campaign is not active");
        _;
    }
     
    constructor(string memory _name, string memory _description,uint256 _goal,uint256 _durationIndays){
        name=_name;
        description=_description;
        goal = _goal;
        deadline = block.timestamp + (_durationIndays*1 days);
        owner = msg.sender;
        state=CampaignState.Active;
    }

    function checkAndUpdate() internal {
        if(state==CampaignState.Active)
        {
            if(block.timestamp >= deadline){
                state = address(this).balance >= goal ? CampaignState.Successfull : CampaignState.Failed;

            }
            else{
                state = address(this).balance >= goal ? CampaignState.Successfull : CampaignState.Active;

            }
        }
    }

    function fund(uint256 _tierIndex) public payable campaignOpen{
        
        require(block.timestamp < deadline,"Fundraising period has ended");
        require(_tierIndex < tier.length," Invalid tier");
        require(msg.value == tier[_tierIndex].amount,"Incorrect amount");
        tier[_tierIndex].backers++;
        backers[msg.sender].totalContribution+= msg.value;
        backers[msg.sender].fundedTiers[_tierIndex] = true;
        checkAndUpdate();
       
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
        checkAndUpdate();
        require(state == CampaignState.Successfull,"Campaign state is not sucessfull");
        require(address(this).balance >= goal,"Goal had not been reach");
        
        uint256 balance = address(this).balance;
        require(balance > 0,"No balance to withdraw");

        payable(owner).transfer(balance);
    }

    function getContractBalance() public view returns(uint256) {

        return address(this).balance;   
    }
    function refund()public {
        checkAndUpdate();
        require(state == CampaignState.Failed,"Refunds not allowed");
        uint256 amount = backers[msg.sender].totalContribution;
        require(amount > 0,"No contribution to refund");
        backers[msg.sender].totalContribution=0;
        payable(msg.sender).transfer(amount);

    }

    function hasFunded(address _backer,uint256 _tierIndex)public view returns(bool){
        return backers[_backer].fundedTiers[_tierIndex];
    }
}
