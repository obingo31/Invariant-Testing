//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract PrecisionLoss {
    uint256 constant le12 = 1e12;

    function ussdAmountToBuy(uint256 ussdAmount, uint256 daiAmount) public pure returns (uint256) {
        return (ussdAmount - daiAmount / le12) / 2 * le12; // This will show precision loss
    }

    function ussdModifiedAmountToBuy(uint256 ussdAmount, uint256 daiAmount) public pure returns (uint256) {
        return (ussdAmount - daiAmount / le12) * le12 / 2;
    }
}
