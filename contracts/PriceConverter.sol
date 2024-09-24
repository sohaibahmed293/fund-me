// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    function getPrice() internal view returns (uint256) {
        // to reach out and work with a contract, we need 2 things
        // 1. Address (ETH/USD) Sepolia   0x694AA1769357215DE4FAC081bf1f309aDC325306
        // 2. ABI

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price, , ,) = priceFeed.latestRoundData();
        // price of ETH in terms of USD

        return uint256(price * 1e10);

    }

    // returns price in USD but with 18 0's
    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethAmount * ethPrice) / 1e18;
        return ethAmountInUSD;
    }
}