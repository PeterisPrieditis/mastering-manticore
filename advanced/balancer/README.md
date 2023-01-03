https://github.com/balancer-labs/balancer-core/tree/master/manticore

// -it interactive mode, --rm delete container, -v add volume
docker run -it --rm -v "$PWD":/mastering-manticore pprieditis/mastering-manticore
// go to folder and switch compiler
cd /mastering-manticore/advanced/balancer && solc-select use 0.5.12

python3 ./TBPoolJoinExit.py
python3 TBPoolJoinExitNoFee.py
python3 TBPoolJoinPool.py

exit
