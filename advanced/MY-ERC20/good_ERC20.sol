// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.11;

import "./OZ-contracts/contracts/token/ERC20/ERC20.sol";

contract custom_ERC20 is ERC20 {
    constructor() ERC20("Vanilla ERC20", "GOOD") {}
}