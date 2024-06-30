//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.8.25; //which version of sol compiler we are using

contract Voting //contract start
{
    struct Candidate // A structure defining election candidate attributes. 
    //using a struct so we can have multiple candidates with attributes and can access each candidate using a uint mapping
    // 0 -> candidate1
    // 1 -> candidate2 and so on..
    {
        uint CandidateID;
        string Name;
        uint VoteCount;
    }
    mapping(uint => Candidate) Candidates;
    //a key-value pair of an integer and candidate structure. So we can access candidates using integers in array and loops easier
    mapping(address => bool) Voter; // a key-value pair of voters address with a bool to check if the voter has cast vote or not
    // initially its false so every voter has not cast vote
    uint CandidateNo; // an integer, used to access candiadtes of the struture and keep check of number of candidates
    
    address public Owner;// The Address of Owner of the contract. the one who initializes it

    constructor()// Runs when deploying contract
    {
        Owner = msg.sender;
        //gives address of person runnig the smart contract and sets it in Owner address
    }
    modifier OnlyManager() // a function that acts like a if statement, if require is true then run else print the error
    {// used to check if the person using contract is owner or not.
        require(msg.sender == Owner, "You are not the Owner");
        _; 
    }

    function AddCandidate(string calldata _name) public OnlyManager// we take candidate name as input
    //funcction to add elecrion candidates, and only manager can use it becuase of OnlyManager modifier.
    {
        //We are making a _candidate struct object and setting it as first enter of the struct
        //Initially Candidates[candidateNo] = Candidates[0] so its first electrion candidate enter.
        //we set its attributes and increment the CandidateNo interger so that next candidate is always different and doesnt
        //override this one.
        Candidate storage _candidate = Candidates[CandidateNo];
        _candidate.Name = _name;
        _candidate.CandidateID = CandidateNo;
        _candidate.VoteCount = 0; //initally votes are 0
        CandidateNo++;
    }
    
    function Vote(uint CandidateId) public // We take candidate id as input for voting
    {
        require(Voter[msg.sender] == false, "You have already Voted");// if Voter who is using this function has not voted 
        //then it will be == false and we can vote else we will stop here as we have voted and can only cast 1 vote.
        require(CandidateId < CandidateNo);// the input candidateID for vote should be elss then total candidates, no illegal entry
        //also since its uint, it cant be negative
        Voter[msg.sender] = true; // we set vote to true so we cant cast vote again.
        Candidates[CandidateId].VoteCount += 1;// add vote to the candidates vote count.
    }
 
    function ViewCandidate(uint ID) public view returns(uint, string memory, uint)
    //We can see a specific candidates result by inputing their id.
    {
        return (Candidates[ID].CandidateID, Candidates[ID].Name,Candidates[ID].VoteCount);
    }

    function AllCandidate() public view returns(uint[] memory, string[] memory, uint[] memory)
    //to see all candidates result, we store candidates and their attributes in arrays and then loop over them and output it
    {
        uint[] memory ids= new uint[](CandidateNo);
        string[] memory name= new string[](CandidateNo);
        uint[] memory voteCount= new uint[](CandidateNo);

        uint i; //0
        while(i < CandidateNo)
        {
            ids[i] = Candidates[i].CandidateID;
            name[i] = Candidates[i].Name;
            voteCount[i] = Candidates[i].VoteCount;
            i++;
        }
        return(ids,name,voteCount);
    }
}