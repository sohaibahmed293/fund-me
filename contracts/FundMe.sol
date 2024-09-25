// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

// Get funds from users
// Withdraw funds
// set a minimum funding value in USD

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    // variables that are assigned value once when they declared are made constant
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;

    // variables that are assigned value once but not where they are declared are made immutable
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable  {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't sent enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {

        // step 1: Reset mappings
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // step 2: Reset funders array
        funders = new address[](0);

        // step 3: Withdraw funds

        // Three ways to withdraw funds:
        // 1. transfer
        // payable(msg.sender).transfer(address(this).balance);

        // 2. send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // 3. call (This is used most of the times)
        // type case msg.sender from address type to payable address type
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}(""); 
        require(callSuccess, "Call failed");        

    }

    modifier onlyOwner() {
        // only an owner can withdraw funds
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    function getVersion() internal view returns (uint256) {
       return AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).version();
    }

    // receiver function is called even when there's no transaction calldata
    // while fallback function is similar to receive function and is called even with the data too
    // both are special funcs in solidity

    receive() external payable { 
        fund();
    }

    fallback() external payable { 
        fund();
    }
}