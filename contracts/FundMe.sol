// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

// Get funds from users
// Withdraw funds
// set a minimum funding value in USD

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    address[] public funders;

    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable  {
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't sent enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public  {}
}