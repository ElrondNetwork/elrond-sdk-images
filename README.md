# elrond-sdk-images

Docker images useful for Smart Contract developers.

## Frozen images

Images having a tag with the prefix `frozen` (e.g. `frozen-001`) will never be updated upon publishing (in the public registry). These images should be used, for example, for reproducible (deterministic) builds of Smart Contracts.


```
# Reproducible contract builds using Docker

export REPOSITORY_ON_HOST=/home/andrei/Desktop/workspace/LESS_USED/sc-launchpad-rs
export REPOSITORY_IN_CONTAINER_BUFFER_ZONE=/tmp/elrond
export REPOSITORY_IN_CONTAINER=/home/elrond/sc-launchpad-rs
export OUTPUT_ON_HOST=/home/andrei/docker-output
export OUTPUT_IN_CONTAINER=/home/elrond/output
export IMAGE=elrond-sdk-erdpy-rust:frozen-004

# Make sure the output folder is owned by the user elrond:elrond.
sudo chown -R elrond:elrond ${OUTPUT_ON_HOST}

# Mount two folders into the container:
# - input: REPOSITORY_ON_HOST
# - output: OUTPUT_ON_HOST

docker run -it \
--mount type=bind,source=${REPOSITORY_ON_HOST},destination=${REPOSITORY_IN_CONTAINER_BUFFER_ZONE} \
--mount type=bind,source=${OUTPUT_ON_HOST},destination=${OUTPUT_IN_CONTAINER} \
--rm \
--entrypoint /bin/bash \
${IMAGE} \
-c "\
cp -r ${REPOSITORY_IN_CONTAINER_BUFFER_ZONE} ${REPOSITORY_IN_CONTAINER} && \
cd ${REPOSITORY_IN_CONTAINER} && \
erdpy contract clean --recursive && \
erdpy contract build --recursive && \
find ${REPOSITORY_IN_CONTAINER} -name *.wasm -exec cp {} ${OUTPUT_IN_CONTAINER} \; &&\
find ${REPOSITORY_IN_CONTAINER} -name *.abi.json -exec cp {} ${OUTPUT_IN_CONTAINER} \;\
"

# Now give back ownership over ${OUTPUT_ON_HOST} to the current user.
sudo chown -R $USER ${OUTPUT_ON_HOST}

for i in $(find ${OUTPUT_ON_HOST} -type f); do
    filename=$(basename ${i})
    checksum=($(b2sum -l 256 ${i}))
    echo "${filename}: ${checksum}"
done
```

```
# At first, the user elrond:elrond might now exist. This is how you create it:
sudo groupadd -r elrond
sudo useradd --no-log-init --no-create-home -g elrond elrond
```

```
# Optionally, if you'd like to remove the user "elrond" afterwards, do as follows.
# MAKE SURE THE USER "elrond:elrond" IS NOT USED ON YOUR SIDE!
sudo deluser elrond
sudo delgroup elrond
```

```
export REPOSITORY_ON_HOST=/home/andrei/Desktop/workspace/LESS_USED/sc-launchpad-rs
export REPOSITORY_IN_CONTAINER=/home/elrond/sc-launchpad-rs
export IMAGE=elrond-sdk-erdpy-rust:frozen-004

# Make sure the folder is owned by the user elrond:elrond.
sudo chown -R elrond:elrond ${REPOSITORY_ON_HOST}

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

# Now give back ownership over ${OUTPUT_ON_HOST} to the current user.
sudo chown -R $USER ${REPOSITORY_ON_HOST}

for i in $(find ${REPOSITORY_ON_HOST} -type f -name *.wasm); do
    filename=$(basename ${i})
    checksum=($(b2sum -l 256 ${i}))
    echo "${filename}: ${checksum}"
done
```
