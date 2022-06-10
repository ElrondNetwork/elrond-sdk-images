# elrond-sdk-images

Docker images useful for Smart Contract developers.

## Frozen images

Images having a tag with the prefix `frozen` (e.g. `frozen-001`) will never be updated upon publishing (in the public registry). These images should be used, for example, for reproducible (deterministic) builds of Smart Contracts.

## Reproducible builds

This section is a step-by-step guide for reproducing a contract build, given its source code and the name (tag) of a _frozen_ Docker image that was used for its previous build (that we want to reproduce).

### Preparing the environment

First, let's export some variables:

```
export REPOSITORY_ON_HOST=~/my-contracts/sc-adder-rs
export REPOSITORY_IN_CONTAINER=/home/elrond/sc-adder-rs
export IMAGE=elrond-sdk-erdpy-rust:frozen-004
```

The latter explicitly selects the _frozen_ Docker image to be used.

### Adding the user `elrond:elrond`

At first, the user `elrond:elrond` (necessary to run the steps below) might not exist on your host. This is how you create it:

```
sudo groupadd -r elrond
sudo useradd --no-log-init --no-create-home -g elrond elrond
```

Optionally, if you'd like to remove the user `elrond` upon building the contract, do as follows:

```
sudo deluser elrond
sudo delgroup elrond
```

Though, **make sure the user `elrond:elrond` is not used on your side**, before attempting to delete it!

### Permissions on host

On the host, make sure the folder containing the source code is owned by the (newly created) user `elrond:elrond`.

```
sudo chown -R elrond:elrond ${REPOSITORY_ON_HOST}
```

### Performing the build

Now we can build the contract by invoking the following `docker run` command:

```
docker run -it \
--mount type=bind,source=${REPOSITORY_ON_HOST},destination=${REPOSITORY_IN_CONTAINER} \
--rm \
--entrypoint /bin/bash \
${IMAGE} \
-c "\
cd ${REPOSITORY_IN_CONTAINER} && \
erdpy contract clean --recursive && \
erdpy contract build --recursive\
"

```

### Permissions over the output

Now give back ownership over `${OUTPUT_ON_HOST}` to the current user (your user on the host):

```
sudo chown -R $USER ${REPOSITORY_ON_HOST}
```

### Computing the codehash

Once the build is ready, you can compute the codehash of the `*.wasm` files, as follows:

```
for i in $(find ${REPOSITORY_ON_HOST} -type f -name *.wasm); do
    filename=$(basename ${i})
    checksum=($(b2sum -l 256 ${i}))
    echo "${filename}: ${checksum}"
done
```

## Using the localnet

The image [elrond-sdk-localnet:latest.dockerfile](https://hub.docker.com/r/elrondnetwork/elrond-sdk-localnet) allows one to easily start an erdpy localnet.

At first, start the container in the _interactive_ mode:

```
docker run --rm -it elrondnetwork/elrond-sdk-localnet:latest
```

Once reaching the container shell, start the localnet as follows:

```
erdpy testnet start
```

The Proxy should now be available from the host, at `http://localhost:7950`.
