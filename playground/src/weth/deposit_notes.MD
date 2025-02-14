$ forge test --match-path src/weth/deposit.t.sol -vvvv
[⠢] Compiling...
No files changed, compilation skipped

Ran 1 test for src/weth/deposit.t.sol:WETH9_Deposit_Test
[PASS] test_WhenDepositIsCalled() (gas: 44592)
Traces:
  [44592] WETH9_Deposit_Test::test_WhenDepositIsCalled()
    ├─ [2574] WETH9.0.8.0::balanceOf(WETH9_Deposit_Test: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496]) [staticcall]
    │   └─ ← [Return] 0
    ├─ [0] VM::deal(WETH9_Deposit_Test: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496], 1000000000000000000 [1e18])
    │   └─ ← [Return] 
    ├─ [0] VM::expectEmit(true, true, false, true)
    │   └─ ← [Return] 
    ├─ emit Deposit(dst: WETH9_Deposit_Test: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496], wad: 1000000000000000000 [1e18])
    ├─ [0] VM::prank(WETH9_Deposit_Test: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496])
    │   └─ ← [Return] 
    ├─ [21945] WETH9.0.8.0::deposit{value: 1000000000000000000}()
    │   ├─ emit Deposit(dst: WETH9_Deposit_Test: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496], wad: 1000000000000000000 [1e18])
    │   └─ ← [Stop] 
    ├─ [574] WETH9.0.8.0::balanceOf(WETH9_Deposit_Test: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496]) [staticcall]
    │   └─ ← [Return] 1000000000000000000 [1e18]
    ├─ [0] VM::assertEq(1000000000000000000 [1e18], 1000000000000000000 [1e18], "Balance should increase by msg.value") [staticcall]
    │   └─ ← [Return] 
    └─ ← [Stop] 

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 1.51ms (426.40µs CPU time)

Ran 1 test suite in 821.44ms (1.51ms CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)