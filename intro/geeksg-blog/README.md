securing-your-smart-contracts-with-symbolic-executions-part-1.md

// -it interactive mode, --rm delete container, -v add volume
docker run -it --rm -v "$PWD":/mastering-manticore pprieditis/mastering-manticore
// go to folder and switch compiler
cd /mastering-manticore/intro/geeksg-blog && solc-select use 0.5.9
// To run the test for the correct contract
manticore-verifier contract.sol --contract SimpleContractTest
// To run the test for the incorrect contract
manticore-verifier contract.sol --contract RogueContractTest
exit
