// -it interactive mode, --rm delete container after use, -v add volume
docker run -it --rm -v "$PWD":/mastering-manticore pprieditis/mastering-manticore
// go to folder and switch compiler
cd /mastering-manticore/advanced/MY-ERC20 && solc-select use 0.8.11
python3 ERC20.py good_ERC20.sol good_ERC20
python3 ERC20.py bad_ERC20.sol custom_ERC20
exit
