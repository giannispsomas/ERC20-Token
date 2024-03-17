// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GamerzToken
 * @dev A simple ERC-20 token contract built from scratch.
 */
contract GamerzToken {

    string public name; // Token name
    string public symbol; // Token symbol
    uint8 public immutable decimals; // Token decimals
    uint256 public immutable totalSupply; // Total token supply

    mapping(address => uint256) private _balance; // The balances of the token holders
    mapping(address => mapping(address => uint256)) private _allowances; // Allowed token transfers

    event Transfer(address indexed from, address indexed to, uint256 value); // Emitted when tokens are transferred
    event Approval(address indexed owner, address indexed spender, uint256 value); // Emitted when approval is granted by the contract owner

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
        _balance[msg.sender] = totalSupply; // Assign total supply to contract deployer
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
        require(to != address(0), "Invalid recipient address!"); // Ensure recipient address is valid
        require(value > 0, "Transfer amount must be greater than zero!"); // Ensure transfer value is greater than zero
        require(_balance[msg.sender] >= value, "Insufficient balance!"); // Ensure sender has enough balance

        _balance[msg.sender] -= value; // Subtract tokens from sender
        _balance[to] += value; // Add tokens to recipient
        emit Transfer(msg.sender, to, value); // Emit Transfer event
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
        require(from != address(0), "Invalid sender address!"); // Ensure sender address is valid
        require(to != address(0), "Invalid recipient address!"); // Ensure recipient address is valid
        require(value > 0, "Transfer amount must be greater than zero!"); // Ensure transfer value is greater than zero
        require(_balance[from]>= value, "Insufficient sender balance!"); // Ensure sender has enough balance
        require(_allowances[from][msg.sender] >= value, "Insufficient allowance!"); // Ensure allowance is sufficient

        _balance[from] -= value; // Subtract tokens from sender
        _balance[to] += value; // Add tokens to recipient
        _allowances[from][msg.sender] -= value; // Subtract allowance
        emit Transfer(from, to, value); // Emit Transfer event
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * @param spender The address which will spend the tokens.
     * @param value The amount of tokens to be spent.
     * @return A boolean that indicates whether the operation was successful.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Invalid spender address!"); // Ensure spender address is valid
        
        _allowances[msg.sender][spender] = value; // Set spender's allowance
        emit Approval(msg.sender, spender, value); // Emit Approval event
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
