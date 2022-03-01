FROM elrondnetwork/elrond-sdk-erdpy:frozen-001

LABEL rust="nightly-2022-02-26"
LABEL wasm-opt="105"
LABEL nodejs="v12.18.3"
LABEL vmtools="v1.4.42"

USER elrond:elrond
RUN erdpy deps install rust --tag="nightly-2022-02-26" && rm -f ~/elrondsdk/*.tar.gz
RUN erdpy deps install nodejs --tag="v12.18.3" && rm -f ~/elrondsdk/*.tar.gz
RUN erdpy deps install wasm-opt --tag="N/A" && rm -f ~/elrondsdk/*.tar.gz
RUN erdpy deps install vmtools --tag="v1.4.42" && rm -f ~/elrondsdk/*.tar.gz
USER root
RUN rm -rf ~/elrondsdk/golang
USER elrond:elrond