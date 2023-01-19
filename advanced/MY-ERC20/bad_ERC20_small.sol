// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.11;

contract custom_ERC20 {
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    address immutable _deployer;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        uint256 fromBalance = _balances[owner];
        _balances[owner] = fromBalance - amount;
        _balances[to] += amount;
        return true;
    }
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function _mint(address account, uint256 amount) public {
        _totalSupply += amount;
        _balances[account] += amount;
    }
}