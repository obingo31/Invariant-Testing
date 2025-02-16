# Internal Properties Testing Workflow 

## Overview
We are using Echidna to test ERC20 token implementations against a set of predefined properties to verify correctness.

## Directory Structure
```bash
/home/malo/Invariant-Testing/playground/properties/
├── CryticERC20InternalHarness.sol  # Test harness
├── MyToken.sol                     # Token implementation
├── echidna-internal.yaml          # Main config
└── contracts/
    └── ERC20/
        └── internal/
            ├── echidna.config.yaml # Internal testing config
            └── properties/
                └── ERC20BasicProperties.sol # Property definitions
```
## Workflow

### Create Test Harness

// filepath: /home/malo/Invariant-Testing/playground/properties/CryticERC20InternalHarness.sol

```java

pragma solidity ^0.8.0;

import "@crytic/properties/contracts/ERC20/internal/properties/ERC20BasicProperties.sol";
import "./MyToken.sol";

contract CryticERC20InternalHarness is MyToken, CryticERC20BasicProperties {
    constructor() MyToken("Test Token", "TST") {
        _mint(USER1, INITIAL_BALANCE);
        _mint(USER2, INITIAL_BALANCE);
        _mint(USER3, INITIAL_BALANCE);
        initialSupply = totalSupply();
    }
    // ... override functions ...
}
```         
### Configure Echidna
```yml
# filepath: /home/malo/Invariant-Testing/playground/properties/echidna-internal.yaml
corpusDir: "tests/crytic/erc20/echidna-corpus-internal"
testMode: assertion
testLimit: 100000
deployer: "0x10000"
sender: ["0x10000", "0x20000", "0x30000"]
```
### Run Tests 

```bash
# Execute internal property tests
echidna CryticERC20InternalHarness.sol --contract CryticERC20InternalHarness --config echidna-internal.yaml
```

### Example Properties Tested
from ERC20Basicproperties.sol:

- Total supply consistency
- Balance constaraints
- Transfer validations
- Zero address restrictions

CMDs
```bash
# Check file locations
find ../lib/properties -name "ERC20BasicProperties.sol"

# Verify remappings
forge remappings

# Run Echidna tests
echidna CryticERC20InternalHarness.sol --contract CryticERC20InternalHarness --config echidna-internal.yaml
```
* configured remappings like so:

```js
@crytic/=../lib/properties/
```
```js
Test harness must:

- Inherit from both token implementation and properties contract
- Override conflicting functions
- Initialize test accounts with proper balances
- Set initial supply for testing

Configuration files control:
- Test limits
- Test mode (assertion)
- Test accounts
- Coverage reporting
```