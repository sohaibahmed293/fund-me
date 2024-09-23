// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// Get funds from users
// Withdraw funds
// set a minimum funding value in USD

contract FundMe {

    uint256 public minimumUsd = 5;

    function fund() public payable  {
        require(msg.value >= minimumUsd, "Didn't sent enough ETH");
    }

    function withdraw() public  {}
    function getPrice() public {
        // to reach out and work with a contract, we need 2 things
        // 1. Address (ETH/USD) Sepolia   0x694AA1769357215DE4FAC081bf1f309aDC325306
        // 2. ABI
    }
    function getConversionRate() public {}
}