// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GamerzToken
 * @dev A simple ERC-20 token contract built from scratch.
 */
contract GamerzToken {

    string public name; 
    string public symbol; 
    uint8 public immutable decimals; 
    uint256 public immutable totalSupply;

    mapping(address => uint256) private _balance; 
    mapping(address => mapping(address => uint256)) private _allowances; 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value); 

    /**
     * @dev Constructor function to initialize the contract with token details and supply.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     */
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
        totalSupply = 100000 * (10 ** uint256(decimals));
        _balance[msg.sender] = totalSupply; 
    }

    /**
     * @dev Get the balance of a specified address.
     * @param account The address to query the balance of.
     * @return The balance of the specified address.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balance[account];
    }

    /**
     * @dev Transfer tokens to a specified address.
     * @param to The address to transfer tokens to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean that indicates whether the operation was successful.
     */
    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Invalid recipient address!"); 
        require(value > 0, "Transfer amount must be greater than zero!"); 
        require(_balance[msg.sender] >= value, "Insufficient balance!"); 

        _balance[msg.sender] -= value; 
        _balance[to] += value; 
        emit Transfer(msg.sender, to, value); 
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * @param from The address to transfer tokens from.
     * @param to The address to transfer tokens to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean that indicates whether the operation was successful.
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(from != address(0), "Invalid sender address!"); 
        require(to != address(0), "Invalid recipient address!"); 
        require(value > 0, "Transfer amount must be greater than zero!"); 
        require(_balance[from]>= value, "Insufficient sender balance!"); 
        require(_allowances[from][msg.sender] >= value, "Insufficient allowance!"); 

        _balance[from] -= value; 
        _balance[to] += value; 
        _allowances[from][msg.sender] -= value; 
        emit Transfer(from, to, value); // 
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * @param spender The address which will spend the tokens.
     * @param value The amount of tokens to be spent.
     * @return A boolean that indicates whether the operation was successful.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Invalid spender address!"); 
        
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value); 
        return true;
    }

    /**
     * @dev Get the remaining allowance of tokens granted to an approved spender.
     * @param owner The address which owns the tokens.
     * @param spender The address which will spend the tokens.
     * @return The remaining allowance of tokens granted to the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }
}
