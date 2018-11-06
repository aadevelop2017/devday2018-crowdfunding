pragma solidity ^0.4.17;
contract ProjectFactory{

    event ProjectCreated(address projectAddress);
    
    address[] deployedProjects;
    address public latestProject;
    
    function createProject( 
        address founder, 
        string name,
        address[] sponsors,
        Request[] requests,
        uint minFund) 
        public {
        latestProject = new Project(founder, name, sponsors, requests, minFund);
        deployedProjects.push(latestProject);
        emit ProjectCreated(latestProject);
    }
    
    function getDeployedProjects() public view returns(address[]){
        return deployedProjects;
    }

}


contract Request{
    
    string public title;
    address public targetAccount;
    uint public money;
    address[] public approvedSpronsors;
    bool public approved;
    
    constructor(
        string initTitle,
        address initTargetAccount,
        uint initMoney,
        address[] initApprovedSpronsors,
        bool initApproved
    ) public {
        title = initTitle;
        targetAccount = initTargetAccount;
        money = initMoney;
        approvedSpronsors = initApprovedSpronsors;
        approved = initApproved;
    }
    
}

contract Project{
    
    struct  Option {
        string name;
        uint votedCount;
        mapping(address => bool) voters;
    }
    
    address public founder;
    string public name;
    address[] public sponsors;
    Request[] public requests;
    uint public minFund;
    Option[] public options;
    string public question;

    constructor(
        address initFounder, 
        string initName,
        address[] initSponsors,
        Request[] initRequests,
        uint initMinFund
    ) public {
        founder = initFounder;
        name = initName;
        sponsors = initSponsors;
        requests = initRequests;
        minFund = initMinFund;
    }
    
    event RequestCreated(address requestAddress);
    address[] deployedRequests;
    address public latestRequests;
    
    function createRequest(
        string title,
        address targetAccount,
        uint money,
        address[] approvedSpronsors,
        bool approved    
    ) public {
        latestRequests = new Request(
            title,
            targetAccount,
            money,
            approvedSpronsors,
            approved
        );
        deployedRequests.push(latestRequests);
        emit RequestCreated(latestRequests);
    }
    
    
    function approved(uint[] optionsIndexes) public{
        for (uint i = 0; i < optionsIndexes.length; i++) {
            uint index = optionsIndexes[i];
            Option storage option = options[index];
            require(!option.voters[msg.sender], "The sponsor already approved.");
            option.voters[msg.sender] = true;
            option.votedCount++;
        }
    }
    
    function getSummary() public view returns(string,uint) {
        return (
            question,
            options.length
        );
    }

}