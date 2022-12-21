pragma solidity ^0.5.9;
// Abstract contract for Tester to have access to `fn`
contract FnContract {
    function fn(uint a) public view returns (uint);
}
// Correct Implementation
contract SimpleContract is FnContract {
    function fn(uint a) public view returns (uint){
       if(a == 1337) {
           revert();
       }
       if(a > 10000) {
           return 10000;
       }
       return a;
    }
}
// Incorrect Implementation
contract RogueContract is FnContract{
    function fn(uint a) public view returns (uint){
       if(a == 1337) {
           revert();
       }
       if(a == 10001) {
           return 10000;
       }
       if(a == 3) {
           return 3;
       }
       return 1337;
    }
}
// Tester to be used for both contract
contract Tester is FnContract {
    bool maximum_invariant = true;
    bool impossible_value_invariant = true;
    bool reflect_value_invariant = true;
    function run_maximum_invariant(uint a) public {
        if (fn(a) > 10000){
            maximum_invariant = false;
        }
    }
    function crytic_test_maximum_invariant() view public returns (bool){
        return maximum_invariant;
    }
    function run_impossible_value_invariant(uint a) public {
        if (fn(a) == 1337){
            impossible_value_invariant = false;
        }
    }
   function crytic_test_impossible_value_invariant() view public returns (bool){
        return impossible_value_invariant;
    }
    function run_reflect_value_invariant(uint a) public {
        if (a != 1337 && a < 10000){
            if(fn(a) != a){
                reflect_value_invariant = false;
            }
        }
    }
    function crytic_test_reflect_value_invariant() view public returns (bool){
        return reflect_value_invariant;
    }
}
// Concrete implementation of the contract tests
contract SimpleContractTest is SimpleContract, Tester {}
contract RogueContractTest is RogueContract, Tester {}