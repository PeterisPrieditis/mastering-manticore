# to run in interactive mode and add current folders as a volume
# docker run -it -v "$PWD":/mastering-manticore pprieditis/mastering-manticore

# image from Trail Of Bits with all compiler versions
# command to build a image => docker build -t pprieditis/mastering-manticore .

# docker basic comands https://stackify.com/docker-build-a-beginners-guide-to-building-docker-images/
# Existing docker images from Trail Of Bits
# https://github.com/trailofbits/manticore/blob/master/Dockerfile
# https://github.com/trailofbits/eth-security-toolbox/blob/master/Dockerfile

FROM trailofbits/manticore:latest

# Install all and select the latest version of solc as the default
# SOLC_VERSION is defined to a valid version to avoid a warning message on the output
RUN pip3 --no-cache-dir install solc-select
RUN solc-select install all && SOLC_VERSION=0.8.0 solc-select versions | head -n1 | xargs solc-select use

##############################################################################
# Copy FirePress_Klimax into casper from Github
##############################################################################

RUN mkdir /GitHub