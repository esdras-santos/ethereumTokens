pragma solidity ^0.6.0;

import './IERC20.sol';

contract ERC20 is IERC20{
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping (address => uint256) private _balance;
    mapping (address => mapping (address => uint256)) private _allowed;

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    uint8 private _decimals;

    constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) public{
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = totalSupply;
    }

    function name() external override view returns(string memory){
        return _name;
    }

    function symbol() external override view returns(string memory){
        return _symbol;
    }

    function decimals() external override view returns(uint8){
        return _decimals;
    }

    function totalSupply() external override view returns (uint256){
        return _totalSupply;
    }
  
    function balanceOf(address account) external override view returns (uint256){
        require(account != address(0));
        return _balance[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool){
        require(recipient != address(0));
        require(_balance[msg.sender] >= amount);
        require(msg.sender != recipient);
        _balance[msg.sender] -= amount;
        _balance[recipient] += amount;
        
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external override view returns (uint256){
        require(owner != address(0) && spender != address(0));
        return _allowed[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool){
        require(spender != address(0));
        require(_balance[msg.sender] >= amount);
        if(_allowed[msg.sender][spender] > 0){
            _allowed[msg.sender][spender] = 0;
        }
        _allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool){
        require(recipient != address(0));
        require(_balance[sender] >= amount);
        require(_allowed[sender][msg.sender] >= amount);
        _allowed[sender][msg.sender] -= amount;
        _balance[recipient] += amount;
        _balance[sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

}