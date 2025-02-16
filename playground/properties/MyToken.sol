// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {                                                                             
    constructor() ERC20("NonCompliantToken", "NCT") {}     

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(true, "This contract is not compliant");
        return true;
    }         
}