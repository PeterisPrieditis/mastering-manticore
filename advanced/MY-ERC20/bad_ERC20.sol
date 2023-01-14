// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.11;

import "./OZ-contracts/contracts/token/ERC20/ERC20.sol";

contract custom_ERC20 is ERC20 {
    constructor() ERC20("Bad ERC20", "BAD") {}

    /*function transfer(address to, uint256 amount) public override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount+1);
        return true;
    }*/
    function transfer(address to, uint256 amount) public override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, owner, amount+1);
        return true;
    }
}