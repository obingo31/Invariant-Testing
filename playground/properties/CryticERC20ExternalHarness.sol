// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ExampleToken.sol";
import {ITokenMock} from "@crytic/properties/contracts/ERC20/external/util/ITokenMock.sol";
import {CryticERC20ExternalBasicProperties} from "@crytic/properties/contracts/ERC20/external/properties/ERC20ExternalBasicProperties.sol";
import {CryticERC20ExternalBurnableProperties} from "@crytic/properties/contracts/ERC20/external/properties/ERC20ExternalBurnableProperties.sol";
import {CryticERC20ExternalMintableProperties} from "@crytic/properties/contracts/ERC20/external/properties/ERC20ExternalMintableProperties.sol";
import {CryticERC20ExternalPausableProperties} from "@crytic/properties/contracts/ERC20/external/properties/ERC20ExternalPausableProperties.sol";
import {CryticERC20ExternalIncreaseAllowanceProperties} from "@crytic/properties/contracts/ERC20/external/properties/ERC20ExternalIncreaseAllowanceProperties.sol";
import {PropertiesConstants} from "@crytic/properties/contracts/util/PropertiesConstants.sol";

contract CryticERC20ExternalHarness is CryticERC20ExternalBasicProperties, CryticERC20ExternalBurnableProperties, CryticERC20ExternalMintableProperties, CryticERC20ExternalPausableProperties, CryticERC20ExternalIncreaseAllowanceProperties {
    constructor() {
        // Deploy ERC20 using our compliant token implementation
        token = ITokenMock(address(new CryticTokenMock()));
    }
}

contract CryticTokenMock is ExampleToken, PropertiesConstants {
    bool public isMintableOrBurnable;
    uint256 public initialSupply;

    constructor() {
        _mint(USER1, INITIAL_BALANCE);
        _mint(USER2, INITIAL_BALANCE);
        _mint(USER3, INITIAL_BALANCE);
        _mint(msg.sender, INITIAL_BALANCE);

        initialSupply = totalSupply();
        isMintableOrBurnable = true;
    }
}