pragma solidity ^0.4.15;

/// @title ERC20 Standard Interface
contract ERC20 {
  event Transfer(address indexed _from, address indexed _to, uint _value);
  event Approval(address indexed _owner, address indexed _spender, uint _value);
  function totalSupply() external constant returns (uint256 supply) {}
  function balanceOf(address _owner) external constant returns (uint256 balance) {}
  function transfer(address _to, uint256 _value) external returns (bool success) {}
  function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {}
  function approve(address _spender, uint256 _value) external returns (bool success) {}
  function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {}
}

/// @title Log Various Error Types
contract LoggingErrors {
  event LogErrorString(string errorString);

  /// @dev Default error to simply log the error message and return
  function error(string _errorMessage) internal returns(bool) {
    LogErrorString(_errorMessage);
    return false;
  }
}

/// @dev Math operations with safety checks that throw on error
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/// @title Basic ERC20 Token Implementation
contract Token is ERC20, LoggingErrors {
  using SafeMath for uint256;

  string public constant symbol = 'CCT';
  string public constant name = 'Carbon Credit Token';
  uint public constant decimals = 5;
  uint256 public totalSupply_;
  mapping (address => uint256) public balances_;
  // Allowances that a user has given to another user in order to allow then to spend tokens on their behalf
  // ie. bob => alice => 100 means that bob has approved alice to spend 100 of his tokens.
  mapping(address => mapping (address => uint256)) public allowed_;
  address public owner_; // EOA

  event LogTokensMinted(address indexed _to, uint256 value, uint256 totalSupply);
    function SendDad(uint256 _amount) public returns(bool){

    }
  /// @dev CONSTRUCTOR - set owner account
  function Token() {
    owner_ = msg.sender;
  }

  /// @dev Approve a user to spend your tokens.
  function approve(address _spender, uint256 _amount)
    external
    returns (bool)
  {
    if (_amount <= 0)
      return error('Can not approve an amount <= 0, Token.approve()');

    if (_amount > balances_[msg.sender])
      return error('Amount is greater than senders balance, Token.approve()');

    allowed_[msg.sender][_spender] = allowed_[msg.sender][_spender].add(_amount);

    return true;
  }

function payBalance(address _from, uint256 _burnAmount) public returns (bool){
   if (msg.sender != owner_){
    return error('Burn not completed');
   }
    balances_[_from]= balances_[_from].sub(_burnAmount);
    totalSupply_ = totalSupply_.sub(_burnAmount);
    return true;

}


  /// @dev Mint tokens and allocate them to the specified user.
  function mint (address _to, uint _value) external returns (bool)
  {
    // Only the owner may mint
if (msg.sender != owner_)
  return error('msg.sender != owner, Token.mint()');

if (_value <= 0)
  return error('Cannot mint a value of <= 0, Token.mint()');

    // Can't mint to address(0)
if (_to == address(0))
  return error('Cannot mint tokens to address(0), Token.mint()');

    // Update the total supply and balance of the _to user
    // Increase total supply my value
    // Increase _to in the balance mapping by the value
totalSupply_ = totalSupply_.add(_value);
balances_[_to] = balances_[_to].add(_value);

    // Logs
LogTokensMinted(_to, _value, totalSupply_);
Transfer(address(0), _to, _value);

    return true;
  }

  /// @dev send `_value` token to `_to` from `msg.sender`
  function transfer (
    address _to,
    uint256 _value
  ) external
    returns (bool)
  {
    if (balances_[msg.sender] < _value)
      return error('Sender balance is insufficient, Token.transfer()');

    balances_[msg.sender] = balances_[msg.sender].sub(_value);
    balances_[_to] = balances_[_to].add(_value);

    Transfer(msg.sender, _to, _value);

    return true;
  }

  /// @dev Transfer from one account to another on the from account's behalf
  function transferFrom(address _from, address _to, uint256 _amount)
    external
    returns (bool)
  {
    // Can't transfer amount of 0!
if (_amount <= 0)
  return error('Cannot transfer amount <= 0, Token.transferFrom()');

    // Confirm from has a sufficient balance
if (_amount > balances_[_from])
  return error('From account has an insufficient balance, Token.transferFrom()');

    // Confirm sender has a sufficient allowance
if (_amount > allowed_[_from][msg.sender])
  return error('msg.sender has insufficient allowance, Token.transferFrom()');

    // Move the funds from the _from balance to the _to balance
    // Decrease from's balance by value
    // Incease _to's balance by value
balances_[_from] = balances_[_from].sub(_amount);
balances_[_to] = balances_[_to].add(_amount);

    // Subtract the funds from the sender's allowance
allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_amount);

    // Log
Transfer(_from, _to, _amount);

    return true;
  }

  /// @return the allowance the owner gave the spender
  function allowance(address _owner, address _spender)
    external
    constant
    returns(uint256)
  {
    return allowed_[_owner][_spender];
  }

  /// @return The balance of the owner address
  function balanceOf(address _owner) external constant returns (uint256)
      {
        return balances_[_owner];
      }

  /// @return total amount of tokens.
  function totalSupply ()  external constant returns (uint256){
    return totalSupply_;
  }

  function revenueSize(address _owner, uint256 _value) external returns(uint256 remaining) {


  }

}
