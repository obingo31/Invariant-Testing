// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {PrecisionLoss} from "src/PrecisionLoss/PrecisionLoss.sol";
//import {console2} from "forge-std/src/console2.sol";
// import "forge-std/console2.sol";
import {Test, Vm, console} from "forge-std/Test.sol";

import {CommonBase} from "forge-std/Base.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract InvariantHandler is CommonBase, StdUtils, StdCheats {
    PrecisionLoss internal _underlying;

    uint256 public constant le12 = 1e12;

    uint256 public originalOutput = 1;
    uint256 public newOutput = 1;

    uint256 public maxPrecisionLoss;
    uint256 public mplUssdAmount;
    uint256 public mplDaiAmount;

    constructor(PrecisionLoss underlying) {
        _underlying = underlying;
    }

    function ussdAmountToBuy(uint256 ussdAmount, uint256 daiAmount) public {
        // Bound ussdAmount to a range between 1e6 and 1000000000e6 to ensure it is within acceptable limits
        ussdAmount = bound(ussdAmount, 1e6, 1000000000e6);
        daiAmount = bound(daiAmount, 1e18, 1000000000e18);

        vm.assume(ussdAmount > daiAmount / le12);

        originalOutput = _underlying.ussdAmountToBuy(ussdAmount, daiAmount);
        newOutput = _underlying.ussdModifiedAmountToBuy(ussdAmount, daiAmount);

        uint256 precisionLoss = newOutput > originalOutput ? newOutput - originalOutput : originalOutput - newOutput;

        if (precisionLoss > 0) {
            if (
                precisionLoss > maxPrecisionLoss
                    || (precisionLoss == maxPrecisionLoss && originalOutput == 0 && newOutput > 0)
            ) {
                maxPrecisionLoss = precisionLoss;
                mplUssdAmount = ussdAmount;
                mplDaiAmount = daiAmount;

                console.log("USSD Amount:", ussdAmount);
                console.log("DAI Amount:", daiAmount);
                console.log("Original Output:", originalOutput);
                console.log("New Output:", newOutput);
                console.log("maxPrecision Loss:", maxPrecisionLoss);
                console.log("mplUssdAmount:", mplUssdAmount);
                console.log("mplDaiAmount:", mplDaiAmount);
            }
        }
    }
}
