// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../properties/ExampleToken.sol";

contract ExampleToken_Mint_Test is Test {
    ExampleToken token;
    address owner;
    address nonOwner = address(0xBEEF);
    address target = address(0xCAFE);

    function setUp() external {
        // Deploy the compliant token. The deployer (this contract) becomes the owner.
        token = new ExampleToken();
        owner = address(this);
    }

    // ├── given the sender is not the owner
    // │   └── it should revert
    function test_RevertGiven_TheSenderIsNotTheOwner() external {
        vm.prank(nonOwner); // simulate call from a non-owner
        vm.expectRevert();  // expect revert since only the owner can mint
        token.mint(nonOwner, 100);
    }

    modifier givenTheSenderIsTheOwner() {
        _;
    }

    // └── given the sender is the owner
    //     ├── when amount is zero
    //     │   └── it should revert
    function test_RevertWhen_AmountIsZero() external givenTheSenderIsTheOwner {
        // Assuming minting zero tokens is not allowed, we expect a revert.
        // (Note: if your implementation does not revert zero amounts, adjust this test accordingly.)
        vm.expectRevert();
        token.mint(owner, 0);
    }

    modifier whenAmountIsNotZero() {
        _;
    }

    // └── given the sender is the owner
    //     └── when amount is not zero
    //         └── it should mint
    function test_WhenAmountIsNotZero() external givenTheSenderIsTheOwner whenAmountIsNotZero {
        uint256 amount = 100;
        uint256 initialBalance = token.balanceOf(owner);
        uint256 initialSupply = token.totalSupply();

        token.mint(owner, amount);

        assertEq(token.balanceOf(owner), initialBalance + amount, "Mint failed to update owner balance");
        assertEq(token.totalSupply(), initialSupply + amount, "Mint failed to update total supply");
    }

    modifier givenATargetAddressAndAnAmount() {
        _;
    }

    // ├── given a target address and an amount
    //     ├── when minting tokens
    //         ├── it should update the target's balance
    //         └── it should update the total supply
    function test_WhenMintingTokens()
        external
        givenTheSenderIsTheOwner
        whenAmountIsNotZero
        givenATargetAddressAndAnAmount
    {
        uint256 amount = 100;
        uint256 initialBalance = token.balanceOf(target);
        uint256 initialSupply = token.totalSupply();

        token.mint(target, amount);

        assertEq(token.balanceOf(target), initialBalance + amount, "Mint failed to update target balance");
        assertEq(token.totalSupply(), initialSupply + amount, "Mint failed to update total supply");
    }
}