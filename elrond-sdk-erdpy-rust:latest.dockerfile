FROM elrondnetwork/elrond-sdk-erdpy:latest

USER elrond:elrond
RUN erdpy deps install rust && rm -f ~/elrondsdk/*.tar.gz
RUN erdpy deps install nodejs && rm -f ~/elrondsdk/*.tar.gz
RUN erdpy deps install wasm-opt && rm -f ~/elrondsdk/*.tar.gz
RUN erdpy deps install vmtools && rm -f ~/elrondsdk/*.tar.gz
USER root
# TODO: Run this command after installing "vmtools" in order to reduce the size of the image (or use a "builder").
RUN rm -rf ~/elrondsdk/golang
USER elrond:elrond