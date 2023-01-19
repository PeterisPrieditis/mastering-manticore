// -it interactive mode, --rm delete container after use, -v add volume
docker run -it --rm -v "$PWD":/mastering-manticore pprieditis/mastering-manticore
// go to folder and switch compiler
cd /mastering-manticore/advanced/MY-ERC20 && solc-select use 0.8.11
python3 ERC20.py good_ERC20.sol good_ERC20
python3 ERC20.py bad_ERC20.sol custom_ERC20
python3 ERC20.py bad_ERC20_small.sol custom_ERC20
exit

docker run -it --rm pprieditis/mastering-manticore
docker build .
docker rmi -f $(docker images -q)
docker run -it mastering-manticore
mkdir /GitHub && cd GitHub
export ACCESS_TOKEN=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
git clone https://oauth2:$ACCESS_TOKEN@github.com/PeterisPrieditis/mastering-manticore
cd /GitHub/mastering-manticore/advanced/MY-ERC20 && solc-select use 0.8.11
python3 ERC20.py bad_ERC20.sol custom_ERC20

cd /GitHub && rm -r ./\* && git clone https://oauth2:$ACCESS_TOKEN@github.com/PeterisPrieditis/mastering-manticore && cd /mastering-manticore/advanced/MY-ERC20

docker build --platform linux/amd64 -t mastering-manticore .
docker images
docker tag mastering-manticore gcr.io/manticore-374912/mastering-manticore
docker push gcr.io/manticore-374912/mastering-manticore
docker images gcr.io/manticore-374912/mastering-manticore
docker rmi gcr.io/manticore-374912/mastering-manticore
gcloud run deploy SERVICE --image gcr.io/manticore-374912/mastering-manticore
gcloud run deploy --project=manticore-374912 --image=gcr.io/manticore-374912/mastering-manticore
gcloud run --project=manticore-374912 --image=gcr.io/manticore-374912/mastering-manticore
