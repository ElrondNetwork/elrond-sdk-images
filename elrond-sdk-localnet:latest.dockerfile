FROM elrondnetwork/elrond-sdk-erdpy:latest

RUN erdpy config set dependencies.golang.tag go1.17.6
RUN erdpy config set dependencies.elrond_proxy_go.tag master
RUN erdpy testnet prerequisites && erdpy testnet config


COPY --chown=elrond:elrond ./elrond-sdk-localnet-config/testnet.toml /home/elrond/elrondsdk

EXPOSE 7950
CMD ["/bin/bash"]
