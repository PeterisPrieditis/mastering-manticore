https://github.com/thirdweb-dev/contracts/blob/main/manticore/weth.py

// -it interactive mode, --rm delete container, -v add volume
docker run -it --rm -v "$PWD":/mastering-manticore pprieditis/mastering-manticore
// go to folder and switch compiler
cd /mastering-manticore/advanced/WETH9 && solc-select use 0.8.11
python3 weth.py
exit
