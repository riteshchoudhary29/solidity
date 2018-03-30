# Ethereum <%= contract_name.capitalize  %> dApp (Solidity + Truffle + React)

This is a simple web demo for block chain. that works with Solidity, Truffle and React JS.

## Configration
0. Install curl
  - `sudo apt install curl`

0. Install Go Language 
  - `curl -o https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz`
  - `sudo tar -xvg go1.9.2.linux-amd64.tar.gz`
  - `sudo mv go /usr/local`
  - `sudo gedit .bashrc`
  - `export GOROOT=/usr/local/go`
  - `export GOPATH=$HOME/project/go_project`
  - `export PATH=$GOPATH/bin:$GOROOT/bin:$PATH`
  - `source .bashrc`
  - `go version`

0. Install Ethereum
  - `git clone https://github.com/ethereum/go-ethereum.git`
  - `cd go-ethereum`
  - `git tag`
  - `git checkout tags/v1.8.1 -b dev_ethereum1.8.1`
  - `make all`

0. Install node and npm
  - `curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -`
  - `sudo apt-get install -y nodejs`
  - `sudo apt-get install -y build-essential` 
  - `sudo node -v`
  - `sudo npm -v` 

0. Install truffle 
  - `sudo npm install -g truffle`

0. Install testrpc or ganache-cli 
  - `sudo npm install -g ethereumjs-testrpc`
  - `sudo npm install -g ganache-cli`  

0. Install solc 
  - `cd /usr/lib/node_modules/truffle/`
  - `sudo npm install solc@0.4.21`



## Running


0. Clone this repo
0. `npm install`
0. Make sure `testrpc\ganache-cli` is running on its default port. Then:
0. The Web3 location will be picked up from the `truffle.js` file.
0. The GAS value will be picked up from the `truffle.js` file.
0. Need to set Contract deployment address in  `migrations/2_deploy_contracts.js` file.
  - `truffle compile` - Compile contracts
  - `truffle migrate` - Migrate contracts
  - `truffle migrate --reset` - Migrate already migrated contracts
  - `npm run start` - Starts the development server
  - `truffle test` - Test contracts
  - `npm run build` - Generates a build for production


If you `npm run start`, the app will be available at <http://localhost:3000>.