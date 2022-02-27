FROM elrond-sdk-erdpy:latest

USER elrond:elrond
RUN erdpy deps install rust
RUN erdpy deps install nodejs
RUN erdpy deps install wasm-opt
