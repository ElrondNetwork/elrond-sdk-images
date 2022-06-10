# ===== FIRST STAGE ======
FROM ubuntu:18.04 as builder

RUN apt-get update && apt-get install wget -y
RUN apt-get update && apt-get install python3.8 python3.8-venv python3-venv -y
RUN groupadd -r elrond && useradd --no-log-init --uid 1001 -m -g elrond elrond
USER elrond:elrond
WORKDIR /home/elrond
RUN wget -O erdpy-up.py https://raw.githubusercontent.com/ElrondNetwork/elrond-sdk-erdpy/master/erdpy-up.py
RUN python3.8 ~/erdpy-up.py --exact-version=2.0.0
ENV PATH="/home/elrond/elrondsdk:${PATH}"
RUN erdpy deps install rust --tag="nightly-2022-03-01"
RUN erdpy deps install nodejs --tag="v16.4.2"
RUN erdpy deps install wasm-opt --tag="1.3.0"
RUN erdpy deps install wabt --tag="1.0.27"
RUN rm -rf ~/elrondsdk/*.tar.gz
RUN rm ~/erdpy-up.py

# ===== SECOND STAGE ======
FROM ubuntu:18.04

RUN apt-get update && apt-get install build-essential -y
RUN apt-get update && apt-get install git -y
RUN apt-get update && apt-get install python3.8 python3.8-venv python3-venv -y

RUN groupadd -r elrond && useradd --no-log-init --uid 1001 -m -g elrond elrond
USER elrond:elrond

COPY --from=builder --chown=elrond:elrond /home/elrond/elrondsdk /home/elrond/elrondsdk
ENV PATH="/home/elrond/elrondsdk:${PATH}"

# Build some example contracts in order to prefetch the most common packages (dependencies)
RUN erdpy config set dependencies.elrond_wasm_rs.tag v0.32.0
RUN mkdir -p /home/elrond/prefetch && cd /home/elrond/prefetch && erdpy contract new --template=adder adder && erdpy contract build ./adder
RUN mkdir -p /home/elrond/prefetch && cd /home/elrond/prefetch && erdpy contract new --template=multisig multisig && erdpy contract build ./multisig

WORKDIR /home/elrond

LABEL frozen="yes"
LABEL erdpy="1.4.0"
LABEL rust="nightly-2022-03-01"
LABEL wasm-opt="v1.3.0"
LABEL wasm-opt-binaryen="version_105"
LABEL nodejs="v16.4.2"
LABEL wabt="1.0.27"
LABEL prefetched="elrond-wasm@v0.32.0"
