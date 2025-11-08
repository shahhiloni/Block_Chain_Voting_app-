// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Voting {
string[] public candidates;
mapping(string => uint256) private votes;
mapping(address => bool) public hasVoted;
address public owner;


event Voted(address indexed voter, string candidate, uint256 votesForCandidate);
event CandidateAdded(string candidate);


modifier onlyOwner() {
require(msg.sender == owner, "only owner");
_;
}


constructor(string[] memory initialCandidates) {
owner = msg.sender;
for (uint i = 0; i < initialCandidates.length; i++) {
candidates.push(initialCandidates[i]);
votes[initialCandidates[i]] = 0;
}
}


function addCandidate(string memory name) external onlyOwner {
candidates.push(name);
votes[name] = 0;
emit CandidateAdded(name);
}


function vote(string calldata candidate) external {
require(!hasVoted[msg.sender], "already voted");
bool found = false;
for (uint i = 0; i < candidates.length; i++) {
// cheap string compare
if (keccak256(bytes(candidates[i])) == keccak256(bytes(candidate))) {
found = true;
break;
}
}
require(found, "candidate not found");
votes[candidate] += 1;
hasVoted[msg.sender] = true;
emit Voted(msg.sender, candidate, votes[candidate]);
}


function getVotes(string calldata candidate) external view returns (uint256) {
return votes[candidate];
}


function getCandidates() external view returns (string[] memory) {
return candidates;
}
}