# Welcome to the Plutus Challenge Track 

We have two tracks for you to pick and explore:

- Plutus swap
- Marketplace

# Plutus swap
Here you have a simple swap Plutus validator. You'll have to use it to clear 3 stages.


## Prerequisites

You need to have these ready to start the challenge:

- GHC (8.10.7)
- Cabal (3.6.2.0)
- A running Vasil cardano-node (tag: 1.35.0-rc2)


## Challenge stages

### Stage 1
Understand the code and write a transaction that uses the provided validator using the cardano-cli.

### Stage 2
Make sure your validator is secure!

### Stage 3
Change both the validator's and cardano-cli's code to use:

- Inline datum
- Reference scripts
- Custom collaterals

# Marketplace

One of our partners (dQuadrant) prepared a Marketplace that lives [HERE](https://github.com/dQuadrant/cardano-marketplace).
A description of this example look at the [`Hackathon - NFT Marketplace Challenge - Overview.pdf`](https://github.com/input-output-hk/plutus-community/blob/main/plutus-challenge-track/Hackathon%20-%20NFT%20Marketplace%20Challenge%20-%20Overview.pdf) in this repo.



# Set up your your node

Since we will be exploring Vasil functionalities you also have been added to this vasil-testnet private Discord channel.

👉 If you are tackling dQuadrant's Marketplace challenge ignore these instructions.

👉 If you are tackling the Plutus Swap example you need to run a  in the vasil private testnet. Please follow the links below to configure your node to the latest version (we recommend using binaries rather than Nix):

Node Version: cardano-node 1.35.0-rc2 - linux-x86_64 - ghc-8.10 `git rev 95c3692cfbd4cdb82071495d771b23e51840fb0e`

Download binaries for your architecture from (binaries links point to an older node version 1.33.0 but is still compatible with 1.35.0-rc2): 
- Linux: https://hydra.iohk.io/build/14866208 
- MacOS: https://hydra.iohk.io/build/14866101 
cardano-node run --config config.json --database-path db --socket-path node.socket --topology topology.json

(Linux or MacOS recommended, Windows build is not fully supported on testnet)

👉 If you have a NixOS you can also build the node with Nix:
`git clone https://github.com/input-output-hk/cardano-world` 
`DATA_DIR=/home/sam/.local/share/bitte/cardano ENVIRONMENT=vasil-qa SOCKET_PATH=$(pwd)/node.socket nix run .#x86_64-linux.cardano.entrypoints.cardano-node`
