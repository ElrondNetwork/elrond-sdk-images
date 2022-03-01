FROM ubuntu:18.04

LABEL erdpy="1.0.25"
LABEL frozen="yes"

RUN apt-get update && apt-get install wget -y
RUN apt-get update && apt-get install python3.8 python3.8-venv python3-venv -y
RUN apt-get update && apt-get install git -y
RUN apt-get update && apt-get install build-essential -y
RUN groupadd -r elrond && useradd --no-log-init --uid 1001 -m -g elrond elrond
USER elrond:elrond
WORKDIR /home/elrond
RUN wget -O erdpy-up.py https://raw.githubusercontent.com/ElrondNetwork/elrond-sdk-erdpy/master/erdpy-up.py
RUN python3.8 ~/erdpy-up.py --exact-version=1.0.25
ENV PATH="/home/elrond/elrondsdk:${PATH}"