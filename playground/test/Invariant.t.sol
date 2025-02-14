//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {PrecisionLoss} from "src/PrecisionLoss/PrecisionLoss.sol";
import {InvariantHandler} from "./handler.sol";

import "forge-std/console2.sol";
import {Test, Vm, console} from "forge-std/Test.sol";

contract InvariantTest is Test {
    PrecisionLoss internal _underlying;
    // handler exposes real contract
    InvariantHandler internal _handler;

    function setUp() public {
        _underlying = new PrecisionLoss();
        _handler = new InvariantHandler(_underlying);

        targetContract(address(_handler));

        //functions to target during invariant test
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = _handler.ussdAmountToBuy.selector;

        targetSelector(FuzzSelector({addr: address(_handler), selectors: selectors}));
    }

    function invariant_originalOutputNotZero() public view {
        assert(_handler.originalOutput() != 0);
    }
}
