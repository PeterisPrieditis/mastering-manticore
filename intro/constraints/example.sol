// solc 0.5.11 is recommended.
contract Simple {
    function f(uint a) payable public{
        if (a == 65) {
            revert();
        }
    }
}