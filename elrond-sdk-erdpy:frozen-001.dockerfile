# ===== FIRST STAGE ======
FROM ubuntu:18.04 as builder

RUN apt-get update && apt-get install wget -y
RUN apt-get update && apt-get install python3.8 python3.8-venv python3-venv -y
RUN groupadd -r elrond && useradd --no-log-init --uid 1001 -m -g elrond elrond
USER elrond:elrond
WORKDIR /home/elrond
RUN wget -O erdpy-up.py https://raw.githubusercontent.com/ElrondNetwork/elrond-sdk-erdpy/master/erdpy-up.py
RUN python3.8 ~/erdpy-up.py --exact-version=1.0.25
RUN rm ~/erdpy-up.py

# ===== SECOND STAGE ======
FROM ubuntu:18.04

LABEL erdpy="1.0.25"
LABEL frozen="yes"

# Most derived images will require: git, build-essential.
RUN apt-get update && apt-get install build-essential -y
RUN apt-get update && apt-get install git -y
RUN apt-get update && apt-get install python3.8 python3.8-venv python3-venv -y
RUN groupadd -r elrond && useradd --no-log-init --uid 1001 -m -g elrond elrond
USER elrond:elrond
WORKDIR /home/elrond
COPY --from=builder --chown=elrond:elrond /home/elrond/elrondsdk /home/elrond/elrondsdk
ENV PATH="/home/elrond/elrondsdk:${PATH}"
