FROM elrondnetwork/elrond-sdk-erdpy:latest

RUN erdpy testnet prerequisites && erdpy testnet config
RUN erdpy config set dependencies.elrond_proxy_go.tag master

EXPOSE 7950
CMD ["erdpy", "testnet", "start"]