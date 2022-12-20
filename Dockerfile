FROM trailofbits/manticore:latest

# Install all and select the latest version of solc as the default
# SOLC_VERSION is defined to a valid version to avoid a warning message on the output
RUN pip3 --no-cache-dir install solc-select
RUN solc-select install all && SOLC_VERSION=0.8.0 solc-select versions | head -n1 | xargs solc-select use
