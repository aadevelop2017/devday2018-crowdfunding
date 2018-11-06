pragma solidity ^0.4.17;
contract PollFactory{

    event PollCreated(address pollAddress);
    
    address[] deployedPolls;
    address public latestPoll;
    function createPoll(string question, int amount) public {
        latestPoll = new Poll(question, amount);
        deployedPolls.push(latestPoll);
        emit PollCreated(latestPoll);
    }
    
    function getDeployedPolls() public view returns(address[]){
        return deployedPolls;
    }

}

contract Poll{

    struct  Option {
        string name;
        uint votedCount;
        mapping(address => bool) voters;
    }

    string public question;
    int public amount;
    Option[] public options;

    constructor(string initQuestion, int initAmount) public {
        question = initQuestion;
        amount =  initAmount;
    }

    function createNewOption(string optionName) public {
        Option memory newOption = Option({
            name:optionName,
            votedCount:0
        });
        options.push(newOption);
    }

    function vote(uint[] optionsIndexes) public{
        for (uint i = 0; i < optionsIndexes.length; i++) {
            uint index = optionsIndexes[i];
            Option storage option = options[index];
            require(!option.voters[msg.sender], "The voter already voted.");
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