// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract election {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only the owner can call this function!");
        _;
    }

    enum gender {
        Men,
        Women
    }

    struct Person {
        string name;
        string surname;
        uint256 age;
        gender gender;
    }

    address[] public candidates_list;

    mapping(address => uint8) public candidate_vote_count;
    mapping(address => Person) private voters;
    mapping(address => bool) private hasVoted;

    event Voted(Person voter, address Candidate);

    function setCandidates(address candidate_) public onlyOwner {
        candidates_list.push(candidate_);
    }

    function getVotes(address candidate_) public view returns (uint256) {
        return candidate_vote_count[candidate_];
    }

    function getVoter(
        address voterAddress
    ) public view returns (Person memory) {
        return voters[voterAddress];
    }

    function vote(
        string memory name_,
        string memory surname_,
        uint256 age_,
        gender gender_,
        uint256 candidate_index
    ) public {
        require(
            candidate_index < candidates_list.length,
            "Invalid candidate index"
        );

        require(!hasVoted[msg.sender], "You have already voted");

        Person memory newPerson = Person(name_, surname_, age_, gender_);
        voters[msg.sender] = newPerson;
        candidate_vote_count[candidates_list[candidate_index]]++;

        emit Voted(newPerson, candidates_list[candidate_index]);

        hasVoted[msg.sender] = true;
    }
}
