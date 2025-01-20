// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import {CrowdFunding} from "./CrowdFunding.sol";

contract crowdFundingFactory
{
    address public owner;
    bool public paused;

    struct Campaign {
        address campaignAddress;
        address owner;
        string name;
        uint256 creationTime;
    }

    Campaign[] public Campaigns;
    mapping(address => Campaign[]) public userCampaigns;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier notPaused(){
        require(!paused,"Factory is paused");
        _;
    }
    constructor() public {
        owner = msg.sender;
    }

    function createCampaign(string memory _name,string memory _description,uint256 _goal,uint256 _durationIndelays) external notPaused{
        CrowdFunding newCapaign = new CrowdFunding(
            _name,
            _description,
            _goal,
            _durationIndelays,
            msg.sender
        );
        address campaignAddress = address(newCapaign);
        Campaign memory campaign = Campaign({
            campaignAddress: campaignAddress,
            owner: msg.sender,
            name: _name,
            creationTime:block.timestamp
        });

        Campaigns.push(campaign);
        userCampaigns[msg.sender].push(campaign);

    }


    function getUserCampaigns(address _user) external view returns(Campaign[] memory){
        return userCampaigns[_user];
    }

    function getAllCampaigns() external view returns(Campaign[] memory){
        return Campaigns;
    }

    function togglePause()external onlyOwner{
        paused = !paused;
    }

}