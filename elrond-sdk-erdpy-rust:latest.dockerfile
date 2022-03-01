FROM elrondnetwork/elrond-sdk-erdpy:latest

USER elrond:elrond
RUN erdpy deps install rust && rm -f ~/elrondsdk/*.tar.gz
RUN erdpy deps install nodejs && rm -f ~/elrondsdk/*.tar.gz
RUN erdpy deps install wasm-opt && rm -f ~/elrondsdk/*.tar.gz
RUN erdpy deps install vmtools && rm -f ~/elrondsdk/*.tar.gz
USER root
RUN rm -rf ~/elrondsdk/golang
USER elrond:elrond