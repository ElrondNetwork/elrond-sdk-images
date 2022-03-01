# elrond-sdk-images

Docker images useful for Smart Contract developers.

## Frozen images

Images having a tag with the prefix `frozen` (e.g. `frozen-001`) will never be updated upon publishing (in the public registry). These images should be used, for example, for reproducible (deterministic) builds of Smart Contracts.

## TODO

 - Use **builders** in order to reduce the size of the images (then copy ~/elrondsdk in the following stage).
 - Merge Docker layers where applicable.

