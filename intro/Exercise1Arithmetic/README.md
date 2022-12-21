https://github.com/crytic/building-secure-contracts/blob/master/program-analysis/manticore/exercises/exercise1.md

// -it interactive mode, --rm delete container, -v add volume
docker run -it --rm -v "$PWD":/mastering-manticore pprieditis/mastering-manticore
// go to folder and switch compiler
cd /mastering-manticore/intro/Exercise1Arithmetic && solc-select use 0.5.3
python3 solution.py
exit
