contract DepositContract {
    // @notice MAX_DEPOSIT_AMOUNT is the maximum amount that can be deposited into this contract
    uint256 public constant MAX_DEPOSIT_AMOUNT = 1_000_000e18;

    // @notice balances holds user balances
    mapping(address => uint256) public balances;

    // @notice totalDeposited represents the current deposited amount across all users
    uint256 public totalDeposited;

    // @notice Deposit event is emitted after a deposit occurs
    event Deposit(address depositor, uint256 amount, uint256 totalDeposited);

    // @notice deposit allows user to deposit into the system
    function deposit() public payable {
        // Make sure that the total deposited amount does not exceed the limit
        uint256 amount = msg.value;
        require(totalDeposited + amount <= MAX_DEPOSIT_AMOUNT);

        // Update the user balance and total deposited
        balances[msg.sender] += amount;
        totalDeposited += amount;

        emit Deposit(msg.sender, amount, totalDeposited);
    }
}

contract TestDepositContract {

    // @notice depositContract is an instance of DepositContract
    DepositContract depositContract;

    constructor() payable {
        // Deploy the deposit contract
        depositContract = new DepositContract();
    }

    // @notice testDeposit tests the DepositContract.deposit function
    function testDeposit(uint256 _amount) public {
        // Let's bound the input to be _at most_ the ETH balance of this contract
        // The amount value will now in between [0, address(this).balance]
        uint256 amount = clampLte(_amount, address(this).balance);

        // Retrieve balance of user before deposit
        uint256 preBalance = depositContract.balances(address(this));

        // Call the deposit contract with a variable amount
        depositContract.deposit{value: _amount}();

        // Assert post-conditions
        assert(depositContract.balances(address(this)) == preBalance + amount);
        // Add other assertions here
    }

    // @notice clampLte returns a value between [a, b]
    function clampLte(uint256 a, uint256 b) internal returns (uint256) {
        if (!(a <= b)) {
            uint256 value = a % (b + 1);
            return value;
        }
        return a;
    }

}
