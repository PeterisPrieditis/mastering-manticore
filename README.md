# A collection of resources to master Manticore

This is my first repo to try to use Mantocore for symbolic execution. A lot of people have issues with Manticore set-up and symbolic execution requires beefy hardware so probably the best way to use Manticore is via a Docker. I'm using a custom [Docker image](https://github.com/PeterisPrieditis/mastering-manticore/blob/main/Dockerfile) that I made from Trail Of Bits Docker files. This repo is just a summary of resources that I found in order to learn Manticore.

Docker run with a simple exercise:
```
// -it interactive mode, --rm delete container, -v add volume.
// PWD is an environment variable that your shell will expand to your current working directory.
docker run -it --rm -v "$PWD":/mastering-manticore pprieditis/mastering-manticore 
// go to folder and switch compiler. 
cd /mastering-manticore/intro/Exercise0-Overflow && solc-select use 0.5.11  
python3 my_token.py  
exit  
```

Manticore will output the information in a mcore\_\* directory. Among other, you will find in this directory:

- global.summary: coverage and compiler warnings
- test_XXXXX.summary: coverage, last instruction, account balances per test case
- test_XXXXX.tx: detailed list of transactions per test case

## Docs

- [Manticore’s documentation](https://manticore.readthedocs.io/en/latest/)
- [Manticore: A User-Friendly Symbolic Execution Framework for Binaries and Smart Contracts](https://arxiv.org/pdf/1907.03890.pdf)
- [POLYSWARM SMART CONTRACT HACKING CHALLENGE WRITEUP](https://raz0r.name/writeups/polyswarm-smart-contract-hacking-challenge-writeup/)

## Introduction folder

Property based symbolic executor: manticore-verifier
Securing your smart contracts with symbolic executions - Part 1
https://github.com/yehjxraymond/geeksg-blog/blob/master/content/blog/securing-your-smart-contracts-with-symbolic-executions-part-1.md

Adding Constraints
https://github.com/crytic/building-secure-contracts/blob/master/program-analysis/manticore/adding-constraints.md

## advanced folder

ENS bug
https://medium.com/the-ethereum-name-service/ens-registry-migration-bug-fix-new-features-64379193a5a
https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/manticore

### Trail of Bits links

Manticore Tutorial - https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/manticore

### Balancer Labs

https://github.com/balancer-labs/balancer-core/blob/master/Audit.md
https://github.com/balancer-labs/balancer-core/tree/master/manticore

### Dharma Token (dharma-token)

https://github.com/dharma-eng/dharma-token/blob/master/scripts/mcore-tests/test_fromUnderlying.py

### Dynamic symbol execution detection of smart contract reentry vulnerability

https://github.com/woods1060/M-A-R

### Manticore Ethereum Codelab

https://github.com/wu4f/cs410b-src/tree/master/manticore_labs

### μFragments security tests

https://github.com/ampleforth/uFragments-security-tests/tree/master/manticore
