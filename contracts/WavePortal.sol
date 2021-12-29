// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 private seed;
    uint256 totalWaves;
    // mapping(address => uint) addressWaveCount;
    // address[] addresses;
    mapping(address => uint256) lastWavedAt;
    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    constructor() payable{
        console.log("Yo yo, I am a contract and I am smart");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Try after 15 mins"
        );
        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
        // if(addressWaveCount[msg.sender]==0){
        //     addresses.push(msg.sender);
        // }
        // addressWaveCount[msg.sender] += 1;
        console.log("%s has Waved!", msg.sender, "with message ", _message);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        emit NewWave(msg.sender, block.timestamp, _message);

        seed = (block.timestamp + block.difficulty + seed) % 100;
        if (seed<50) {
            console.log("%s won", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    // function getWavesMapping() public view {
    //     console.log("Mapping: ");
    //     for(uint i=0;i<addresses.length;i++){
    //         console.log(addresses[i], "=>", addressWaveCount[addresses[i]]);
    //     }
    // }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    } 
}
