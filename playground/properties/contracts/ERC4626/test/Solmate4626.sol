pragma solidity ^0.8.0;

// import {ERC20} from "solmate/src/tokens/ERC20.sol";
import "solmate/tokens/ERC20.sol";
import {ERC4626} from "solmate/mixins/ERC4626.sol";
import {CryticERC4626PropertyTests} from "../ERC4626PropertyTests.sol";
import {TestERC20Token} from "../util/TestERC20Token.sol";
import {CryticERC4626SecurityProps} from "../properties/SecurityProps.sol";

/// @notice Basic solmate 4626 impl for property validation/testing.
contract Solmate4626 is ERC4626 {
    uint256 private _totalAssets;

    constructor(ERC20 _asset) ERC4626(_asset, "Test Vault", _asset.symbol()) {}

    function totalAssets() public view virtual override returns (uint256) {
        return _totalAssets;
    }

    function beforeWithdraw(uint256 assets, uint256) internal override {
        _totalAssets = _totalAssets - assets;
    }

    function afterDeposit(uint256 assets, uint256) internal override {
        _totalAssets = _totalAssets + assets;
    }
}

contract TestHarness is CryticERC4626PropertyTests {
    constructor() {
        TestERC20Token _asset = new TestERC20Token("Test Token", "TT", 18);
        ERC4626 _vault = new Solmate4626(ERC20(address(_asset)));
        // Replace msg.sender with a boolean, e.g. true.
        initialize(address(_vault), address(_asset), true);
    }
}
