https://github.com/crytic/building-secure-contracts/blob/master/program-analysis/manticore/exercises/example.md

```
// -it interactive mode, --rm delete container, -v add volume.
// PWD is an environment variable that your shell will expand to your current working directory.
docker run -it --rm -v "$PWD":/mastering-manticore pprieditis/mastering-manticore 
// go to folder and switch compiler. 
cd /mastering-manticore/intro/Exercise0-Overflow && solc-select use 0.5.11  
python3 my_token.py  
exit  
```
