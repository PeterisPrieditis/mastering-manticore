pragma solidity 0.5.12;

contract BConst {
    uint internal constant BONE              = 10**18;

    uint internal constant MAX_BOUND_TOKENS  = 8;
    uint internal constant BPOW_PRECISION    = BONE / 10**10;

    uint internal constant MIN_FEE           = BONE / 10**6;
    uint internal constant MAX_FEE           = BONE / 10;
    uint internal constant EXIT_FEE          = BONE / 10000;

    uint internal constant MIN_WEIGHT        = BONE;
    uint internal constant MAX_WEIGHT        = BONE * 50;
    uint internal constant MAX_TOTAL_WEIGHT  = BONE * 50;
    uint internal constant MIN_BALANCE       = BONE / 10**12;
    uint internal constant MAX_BALANCE       = BONE * 10**12;

    uint internal constant MIN_POOL_SUPPLY   = BONE;

    uint internal constant MIN_BPOW_BASE     = 1 wei;
    uint internal constant MAX_BPOW_BASE     = (2 * BONE) - 1 wei;

    uint internal constant MAX_IN_RATIO      = BONE / 2;
    uint internal constant MAX_OUT_RATIO     = (BONE / 3) + 1 wei;

}
contract BNum is BConst {


    function badd(uint a, uint b)
        internal pure
        returns (uint)
    {
        uint c = a + b;
        require(c >= a);
        return c;
    }

    function bsub(uint a, uint b)
        internal pure
        returns (uint)
    {
        (uint c, bool flag) = bsubSign(a, b);
        require(!flag);
        return c;
    }

    function bsubSign(uint a, uint b)
        internal pure
        returns (uint, bool)
    {
        if (a >= b) {
            return (a - b, false);
        } else {
            return (b - a, true);
        }
    }

    function bmul(uint a, uint b)
        internal pure
        returns (uint)
    {
        uint c0 = a * b;
        require(a == 0 || c0 / a == b);
        uint c1 = c0 + (BONE / 2);
        require(c1 >= c0);
        uint c2 = c1 / BONE;
        return c2;
    }

    function bdiv(uint a, uint b)
        internal pure
        returns (uint)
    {
        require(b != 0);
        uint c0 = a * BONE;
        require(a == 0 || c0 / a == BONE); // bmul overflow
        uint c1 = c0 + (b / 2);
        require(c1 >= c0); //  badd require
        uint c2 = c1 / b;
        return c2;
    }

}

//  This test is similar to TBPoolJoin but with an exit fee
contract TBPoolJoinExit is BNum {

    // joinPool models the BPool.joinPool behavior for one token
    function joinPool(uint poolAmountOut, uint poolTotal, uint _records_t_balance)
        internal pure returns(uint)
    {
        uint ratio = bdiv(poolAmountOut, poolTotal);
        require(ratio != 0);

        uint bal = _records_t_balance;
        uint tokenAmountIn = bmul(ratio, bal);

        return tokenAmountIn;
    }

    // exitPool models the BPool.exitPool behavior for one token
    function exitPool(uint poolAmountIn, uint poolTotal, uint _records_t_balance)
        internal pure returns(uint)
    {
        uint exitFee = bmul(poolAmountIn, EXIT_FEE);
        uint pAiAfterExitFee = bsub(poolAmountIn, exitFee);
        uint ratio = bdiv(pAiAfterExitFee, poolTotal);
        require(ratio != 0);

        uint bal = _records_t_balance;
        uint tokenAmountOut = bmul(ratio, bal);

        return tokenAmountOut;
    }


    // This function model an attacker calling joinPool - exitPool and taking advantage of potential rounding
    // issues to generate free pool token
    function joinAndExitPool(uint poolAmountOut, uint poolAmountIn, uint poolTotal, uint _records_t_balance) public pure {
        uint tokenAmountIn = joinPool(poolAmountOut, poolTotal, _records_t_balance);

        // We constraint poolTotal and _records_t_balance
        // To have "realistic" values
        require(poolTotal <= 100 ether);
        require(poolTotal >= 1 ether);
        require(_records_t_balance <= 10 ether);
        require(_records_t_balance >= 10**6);

        poolTotal = badd(poolTotal, poolAmountOut);
        _records_t_balance = badd(_records_t_balance, tokenAmountIn);

        require(tokenAmountIn > 0); // prevent triggering the free token generation from joinPool 

        require(poolTotal >= poolAmountIn);
        uint tokenAmountOut = exitPool(poolAmountIn, poolTotal, _records_t_balance);
        require(_records_t_balance >= tokenAmountOut);

        // We try to generate free pool share 
        require(poolAmountOut > poolAmountIn); 
        require(tokenAmountOut == tokenAmountIn); 
    }

}