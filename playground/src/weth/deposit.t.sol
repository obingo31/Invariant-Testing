// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "forge-std/Test.sol";
import "./WETH9.sol"; 

contract WETH9_Deposit_Test is Test {
    WETH9 weth;

    event Deposit(address indexed sender, uint256 amount);

    function setUp() public {
        weth = new WETH9();
    }

    function test_WhenDepositIsCalled() external {
        uint256 amount = 1 ether;
        address user = address(this);

        // it should increase the balance of msg.sender by msg.value
        uint256 initialBalance = weth.balanceOf(user);
        vm.deal(user, amount); // Give the contract ETH for testing

        // it should emit a Deposit event with msg.sender and msg.value as parameters
        vm.expectEmit(true, true, false, true);
        emit Deposit(user, amount);

        // Perform deposit action after setting the expectations
        vm.prank(user);
        weth.deposit{value: amount}();

        uint256 finalBalance = weth.balanceOf(user);
        assertEq(finalBalance, initialBalance + amount, "Balance should increase by msg.value");
    }
}
