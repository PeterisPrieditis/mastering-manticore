https://blog.trailofbits.com/2020/03/03/manticore-discovers-the-ens-bug/

// -it interactive mode, --rm delete container, -v add volume
docker run -it --rm -v "$PWD":/mastering-manticore pprieditis/mastering-manticore
// go to folder
cd /mastering-manticore/advanced/ens-bug
// run python
python3 ens.py
exit
