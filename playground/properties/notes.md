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

# Check file locations
find ../lib/properties -name "ERC20BasicProperties.sol"

# Verify remappings
forge remappings

# Run Echidna tests
```bash
echidna CryticERC20InternalHarness.sol --contract CryticERC20InternalHarness --config echidna-internal.yaml
echidna CryticERC20ExternalHarness.sol --contract CryticERC20ExternalHarness --config echidna-external.yaml
* echidna CryticERC20ExternalHarness.sol --contract CryticERC20ExternalHarness --config echidna-internal.yaml
```

### output for external tests
```js
$ echidna CryticERC20ExternalHarness.sol --contract CryticERC20ExternalHarness --config echidna-internal.yaml
[] Compiling CryticERC20ExternalHarness.sol... Done! (3.961234552s)
Analyzing contract: /home/malo/Invariant-Testing/playground/properties/CryticERC20ExternalHarness.sol:CryticERC20ExternalHarness
[] Running slither on CryticERC20ExternalHarness.sol... Done! (7.56801511s)
Loaded 0 transaction sequences from tests/crytic/erc20/echidna-corpus-internal/reproducers
Loaded 19 transaction sequences from tests/crytic/erc20/echidna-corpus-internal/coverage
test_ERC20external_userBalanceNotHigherThanSupply(): passing
test_ERC20external_setAllowanceTwice(address,uint256): passing
test_ERC20external_transferFrom(address,uint256): passing
test_ERC20external_transferFromToZeroAddress(uint256): passing
test_ERC20external_constantSupply(): passing
test_ERC20external_setAllowance(address,uint256): passing
test_ERC20external_transferMoreThanBalance(address): passing
test_ERC20external_transferToZeroAddress(): passing
test_ERC20external_transferFromMoreThanBalance(address): passing
test_ERC20external_zeroAddressBalance(): passing
test_ERC20external_transfer(address,uint256): passing
test_ERC20external_selfTransfer(uint256): passing
test_ERC20external_userBalancesLessThanTotalSupply(): passing
test_ERC20external_transferFromZeroAmount(address): passing
test_ERC20external_transferZeroAmount(address): passing
test_ERC20external_spendAllowanceAfterTransfer(address,uint256): passing
test_ERC20external_selfTransferFrom(uint256): passing
AssertionFailed(..): passing


Unique instructions: 5957
Unique codehashes: 2
Corpus size: 10
Seed: 4077308279260952442
Total calls: 9844
```
* ### Note:
In this harness the underlying token is `ExampleTokenNonCompliant`. 
Its approve function intentionally does nothing (only emits an Approval event), 
so tests that validate allowance updates (like test_ERC20external_setAllowanceTwice & test_ERC20external_setAllowance) are expected to fail, 
highlighting the non‑compliant behavior.

```js
$ echidna CryticERC20ExternalHarness.sol --contract CryticERC20ExternalHarness --config echidna-internal.yaml
[2025-02-16 17:33:44.94] Compiling CryticERC20ExternalHarness.sol... Done! (3.528800398s)
Analyzing contract: /home/malo/Invariant-Testing/playground/properties/CryticERC20ExternalHarness.sol:CryticERC20ExternalHarness
[2025-02-16 17:33:48.88] Running slither on CryticERC20ExternalHarness.sol... Done! (7.425494695s)
Loaded 0 transaction sequences from tests/crytic/erc20/echidna-corpus-internal/reproducers
Loaded 27 transaction sequences from tests/crytic/erc20/echidna-corpus-internal/coverage
test_ERC20external_userBalanceNotHigherThanSupply(): passing
test_ERC20external_setAllowanceTwice(address,uint256): failed!💥  
  Call sequence, shrinking 449/5000:
    CryticERC20ExternalHarness.test_ERC20external_setAllowanceTwice(0x0,1592993401998342340399326218675761333979670059225817386665718)

Traces: 
call CryticTokenMock::approve(address,uint256)(0x0000000000000000000000000000000000000000, 1592993401998342340399326218675761333979670059225817386665718) (/home/malo/Invariant-Testing/playground/lib/properties/contracts/ERC20/external/properties/ERC20ExternalBasicProperties.sol:166)
 ├╴emit Approval(owner=CryticERC20ExternalHarness, spender=0x0000000000000000000000000000000000000000, value=1592993401998342340399326218675761333979670059225817386665718) (/home/malo/Invariant-Testing/playground/properties/ExampleToken.sol:43)
 └╴← (true)
call CryticTokenMock::allowance(address,address)(CryticERC20ExternalHarness, 0x0000000000000000000000000000000000000000) (/home/malo/Invariant-Testing/playground/lib/properties/contracts/ERC20/external/properties/ERC20ExternalBasicProperties.sol:168)
 └╴← (0)
emit AssertEqFail(«Invalid: 0!=1592993401998342340399326218675761333979670059225817386665718, reason: Allowance not set correctly») (/home/malo/Invariant-Testing/playground/lib/properties/contracts/util/PropertiesHelper.sol:117)

test_ERC20external_transferFrom(address,uint256): passing
test_ERC20external_transferFromToZeroAddress(uint256): passing
test_ERC20external_constantSupply(): passing
test_ERC20external_setAllowance(address,uint256): failed!💥  
  Call sequence, shrinking 449/5000:
    CryticERC20ExternalHarness.test_ERC20external_setAllowance(0x0,26184497751207739761938975611560173243462986500)

Traces: 
call CryticTokenMock::approve(address,uint256)(0x0000000000000000000000000000000000000000, 26184497751207739761938975611560173243462986500) (/home/malo/Invariant-Testing/playground/lib/properties/contracts/ERC20/external/properties/ERC20ExternalBasicProperties.sol:159)
 ├╴emit Approval(owner=CryticERC20ExternalHarness, spender=0x0000000000000000000000000000000000000000, value=26184497751207739761938975611560173243462986500) (/home/malo/Invariant-Testing/playground/properties/ExampleToken.sol:43)
 └╴← (true)
call CryticTokenMock::allowance(address,address)(CryticERC20ExternalHarness, 0x0000000000000000000000000000000000000000) (/home/malo/Invariant-Testing/playground/lib/properties/contracts/ERC20/external/properties/ERC20ExternalBasicProperties.sol:168)
 └╴← (0)
emit AssertEqFail(«Invalid: 0!=26184497751207739761938975611560173243462986500, reason: Allowance not set correctly») (/home/malo/Invariant-Testing/playground/lib/properties/contracts/util/PropertiesHelper.sol:117)

test_ERC20external_transferMoreThanBalance(address): passing
test_ERC20external_transferToZeroAddress(): passing
test_ERC20external_transferFromMoreThanBalance(address): passing
test_ERC20external_zeroAddressBalance(): passing
test_ERC20external_transfer(address,uint256): passing
test_ERC20external_selfTransfer(uint256): passing
test_ERC20external_userBalancesLessThanTotalSupply(): passing
test_ERC20external_transferFromZeroAmount(address): passing
test_ERC20external_transferZeroAmount(address): passing
test_ERC20external_spendAllowanceAfterTransfer(address,uint256): passing
test_ERC20external_selfTransferFrom(uint256): passing
AssertionFailed(..): passing


Unique instructions: 6191
Unique codehashes: 2
Corpus size: 6
Seed: 3015683614964674824
Total calls: 6097

[2025-02-16 17:34:13.45] Saving test reproducers... Done! (0.016624095s)
[2025-02-16 17:34:13.47] Saving corpus... Done! (3.110988882s)
[2025-02-16 17:34:16.58] Saving coverage... Done! (0.468485177s)
```

### Interpretation:

The test harness deployed ```CryticTokenMock``` which inherits from ```ExampleTokenNonCompliant```.
The `failed` tests confirm that the ```approve``` function does not `update` ```allowances```, as the ```allowance``` remains `0` while a `nonzero` value was expected.
Other properties `(for transfers, balance limits, etc.)` may pass because they are unaffected by the faulty approval logic.

### Compliant

This test harness deploys a compliant ERC20 token implementation (by using the ExampleToken contract) and runs it against the external ERC20 properties defined in CryticERC20ExternalBasicProperties. In this setup we test that:

Balances are managed correctly (e.g., no user balance exceeds the total supply).
Transfers are validated properly, including restrictions such as transferring to or from the zero address.
Allowance mechanisms work as expected: since we're using the compliant token, the approval function should update allowances accordingly.
Other ERC20 properties (like total supply consistency and proper event emission) are upheld.
By doing this, we have achieved a complete property-based test for a compliant token implementation. All the tests should pass, confirming that our implementation of ExampleToken adheres to the ERC20 standard.

```js
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ExampleToken.sol"; // Contains both compliant and non-compliant token contracts
import {ITokenMock} from "@crytic/properties/contracts/ERC20/external/util/ITokenMock.sol";
import {CryticERC20ExternalBasicProperties} from "@crytic/properties/contracts/ERC20/external/properties/ERC20ExternalBasicProperties.sol";
import {PropertiesConstants} from "@crytic/properties/contracts/util/PropertiesConstants.sol";

contract CryticERC20ExternalHarness is CryticERC20ExternalBasicProperties {
    constructor() {
        // Deploy ERC20 using our compliant token implementation
        token = ITokenMock(address(new CryticTokenMock()));
    }
}

contract CryticTokenMock is ExampleToken, PropertiesConstants {
    bool public isMintableOrBurnable;
    uint256 public initialSupply;

    constructor() {
        // Initialize balances for test accounts
        _mint(USER1, INITIAL_BALANCE);
        _mint(USER2, INITIAL_BALANCE);
        _mint(USER3, INITIAL_BALANCE);
        _mint(msg.sender, INITIAL_BALANCE);

        initialSupply = totalSupply();
        isMintableOrBurnable = true;
    }
}
```
