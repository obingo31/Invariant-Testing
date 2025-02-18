# Property Testing: Playground

In this playground we explore property testing

## Overview
This repository demonstrates comprehensive property-based testing for ERC-20 tokens using Echidna and Bulloak. We'll explore how to validate token implementations against security properties and invariants.

## Base Setup
Our testing harness combines multiple property sets:
- Basic ERC-20 properties
- Burnable token properties
- Mintable token properties
- Pausable functionality
- Advanced allowance management

## Test Structure
The test hierarchy follows this pattern:
```
CryticTokenTest
├── When token is newly deployed
│   ├── It should mint INITIAL_BALANCE to USER1
│   ├── It should mint INITIAL_BALANCE to USER2
│   ├── It should mint INITIAL_BALANCE to USER3
│   ├── It should mint INITIAL_BALANCE to deployer
│   └── It should set isMintableOrBurnable to true
└── [Additional test branches...]
```

## Basic Usage
1. Deploy the test harness:
```solidity
contract CryticERC20ExternalHarness is 
    CryticERC20ExternalBasicProperties,
    CryticERC20ExternalBurnableProperties,
    CryticERC20ExternalMintableProperties,
    CryticERC20ExternalPausableProperties,
    CryticERC20ExternalIncreaseAllowanceProperties {
    constructor() {
        token = ITokenMock(address(new CryticTokenMock()));
    }
}
```

2. Run the tests:
```bash
echidna CryticERC20ExternalHarness.sol --contract CryticERC20ExternalHarness --config echidna-internal.yaml
```

## Core Test Properties
- Balance consistency
- Supply constraints
- Transfer validation
- Allowance management
- Burn/Mint authorization


🔍 **Want to dive deeper?** Check out the full article on Substack for more:

[Read Full Article](https://obingo77.substack.com/p/your-post-slug)
---

## Test Results Preview
```bash
test_ERC20external_userBalanceNotHigherThanSupply(): passing
test_ERC20external_setAllowanceTwice(address,uint256): passing
test_ERC20external_pausedTransfer(address,uint256): passing
[...]
```

## Contributing

# Advanced ERC-20 Property Testing: The Deep Dive

## Understanding the Test Harness

Our test harness combines five critical property sets:

```ruby
contract CryticERC20ExternalHarness is
    CryticERC20ExternalBasicProperties,
    CryticERC20ExternalBurnableProperties,
    CryticERC20ExternalMintableProperties,
    CryticERC20ExternalPausableProperties,
    CryticERC20ExternalIncreaseAllowanceProperties {
     // Implementation
}
```

## Complete Test Output Analysis

Running our test suite yields comprehensive results:
```bash
[2025-02-17 16:15:28.05] Compiling CryticERC20ExternalHarness.sol...
[...full test output...]
Unique instructions: 9398
Unique codehashes: 2
Corpus size: 10
```

## Property Deep Dive
Let's analyze each property category:

run
```bash
echidna_parser.py
```
```js
Tester.mint(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 1000) from: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 Time delay: 0
Tester.transfer(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 500) from: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 Time delay: 50
*wait* Time delay: 100
Tester.approve(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 200) from: 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC Time delay: 0
Tester.transferFrom(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 150) from: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 Time delay: 25
Tester.burn(100) from: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 Time delay: 0
Tester.increaseAllowance(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 300) from: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 Time delay: 75
```

### 1. Basic Properties
- Transfer validation
- Balance checks
- Supply constraints

### lets build the BTT tree

```bash
bulloak scaffold token_properties.tree
``

```ruby
CryticTokenTest
├── When token is newly deployed
│   ├── It should mint INITIAL_BALANCE to USER1
│   ├── It should mint INITIAL_BALANCE to USER2
│   ├── It should mint INITIAL_BALANCE to USER3
│   ├── It should mint INITIAL_BALANCE to deployer
│   └── It should set isMintableOrBurnable to true
├── When transferring tokens
│   ├── When sender has sufficient balance
│   │   ├── It should decrease sender balance
│   │   └── It should increase receiver balance
│   └── When sender has insufficient balance
│       └── It should revert
├── When approving tokens
│   ├── It should set allowance correctly
│   └── When increasing allowance
│       └── It should add to existing allowance
├── When using transferFrom
│   ├── When spender has sufficient allowance
│   │   ├── It should transfer tokens correctly
│   │   └── It should decrease allowance
│   └── When spender has insufficient allowance
│       └── It should revert
└── When burning tokens
    ├── When account has sufficient balance
    │   ├── It should decrease total supply
    │   └── It should decrease account balance
    └── When account has insufficient balance
        └── It should revert
```      

# ERC-20 Test Tree Analysis

## Initial State Verification
### Deployment State Tests
```bash
- Initial token distribution
  - Validates INITIAL_BALANCE minting to USER1, USER2, USER3
  - Confirms deployer allocation
- Contract configuration
  - Verifies isMintableOrBurnable flag state
```

## Core Transfer Functionality
### Direct Transfers
```bash
- Success Cases
  - Balance reduction for sender
  - Balance increase for receiver
  - State consistency checks
- Failure Cases
  - Insufficient balance handling
  - Proper reversion behavior
```  

### Delegated Transfers (transferFrom)
```bash
- Success Path
  - Proper token movement
  - Allowance reduction
  - Balance updates
- Failure Path
  - Insufficient allowance handling
  - Proper reversion behavior
```  

## Allowance Management
### Approval System
```md
- Basic Approval
  - Allowance setting verification
  - Overwrite behavior
- Allowance Increase
  - Increment functionality
  - Accumulation verification
```  

##  Token Supply Management
### Burn Functionality
- Success Conditions
```md
  - Total supply reduction
  - Balance reduction
  - State consistency
- Failure Conditions
  - Insufficient balance handling
  - Proper reversion
```  

## Test Coverage Analysis
**State Management**
```md
   - Initial state validation
   - State transitions
   - Final state verification
```   

 **Error Handling**
   - Explicit reversion cases
   - Edge case management
   - Boundary condition testing

 **Permission Management**
   - Allowance tracking
   - Authorization checks
   - Access control

## Testing Strategy
**Hierarchical Approach**
   - Major functionality groups
   - Sub-functionality testing
   - Edge case coverage

**Failure Mode Testing**
   - Expected reverts
   - State preservation
   - Error conditions

 **State Transition Validation**
   - Pre-condition verification
   - Action execution
   - Post-condition confirmation

# Mapping Bulloak Tree to Echidna Tests

##  "When token is newly deployed" Branch
Corresponding Echidna tests:
- `test_ERC20external_zeroAddressBalance()`
- `test_ERC20external_constantSupply()`
- `test_ERC20external_mintTokens(address,uint256)`

##  "When transferring tokens" Branch
### Sufficient Balance Cases:
- `test_ERC20external_transfer(address,uint256)`
- `test_ERC20external_selfTransfer(uint256)`
- `test_ERC20external_transferZeroAmount(address)`

### Insufficient Balance Cases:
- `test_ERC20external_transferMoreThanBalance(address)`
- `test_ERC20external_transferToZeroAddress()`
- `test_ERC20external_userBalanceNotHigherThanSupply()`
- `test_ERC20external_userBalancesLessThanTotalSupply()`

### Basic Approval:
- `test_ERC20external_setAllowance(address,uint256)`
- `test_ERC20external_setAllowanceTwice(address,uint256)`

### Increasing Allowance:
- `test_ERC20external_setAndIncreaseAllowance(address,uint256,uint256)`
- `test_ERC20external_setAndDecreaseAllowance(address,uint256,uint256)`

## "When using transferFrom" Branch
### Sufficient Allowance:
- `test_ERC20external_transferFrom(address,uint256)`
- `test_ERC20external_selfTransferFrom(uint256)`
- `test_ERC20external_transferFromZeroAmount(address)`
- `test_ERC20external_spendAllowanceAfterTransfer(address,uint256)`

### Insufficient Allowance:
- `test_ERC20external_transferFromMoreThanBalance(address)`
- `test_ERC20external_transferFromToZeroAddress(uint256)`

## "When burning tokens" Branch
### Sufficient Balance:
- `test_ERC20external_burn(uint256)`
- `test_ERC20external_burnFrom(uint256)`
- `test_ERC20external_burnFromUpdateAllowance(uint256)`

## Additional Tests Not Explicitly in Tree
1. Pause Functionality:
   - `test_ERC20external_pausedTransfer(address,uint256)`
   - `test_ERC20external_pausedTransferFrom(address,uint256)`

## Coverage Analysis
```js
- Total Echidna tests: 25 unique test functions
- Instruction coverage: 9398 unique instructions
- Corpus size: 10
- Total calls: 68,736
```

# Run tests

```bash
echidna CryticERC20ExternalHarness.sol --contract CryticERC20ExternalHarness --config echidna-internal.yaml
```

output:

```js
✓ test_ERC20external_constantSupply()
✓ test_ERC20external_userBalanceNotHigherThanSupply()
✓ test_ERC20external_userBalancesLessThanTotalSupply()
✓ test_ERC20external_zeroAddressBalance()
```

```js
✓ test_ERC20external_transfer()
✓ test_ERC20external_transferMoreThanBalance()
✓ test_ERC20external_transferToZeroAddress()
✓ test_ERC20external_transferZeroAmount()
✓ test_ERC20external_selfTransfer()
```

```js
✓ test_ERC20external_setAllowance()
✓ test_ERC20external_setAllowanceTwice()
✓ test_ERC20external_setAndIncreaseAllowance()
✓ test_ERC20external_setAndDecreaseAllowance()
```
```js
✓ test_ERC20external_transferFrom()
✓ test_ERC20external_transferFromMoreThanBalance()
✓ test_ERC20external_transferFromToZeroAddress()
✓ test_ERC20external_transferFromZeroAmount()
✓ test_ERC20external_selfTransferFrom()
✓ test_ERC20external_spendAllowanceAfterTransfer()
```