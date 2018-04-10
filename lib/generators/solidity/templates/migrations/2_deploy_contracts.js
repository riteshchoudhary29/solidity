var truffleConfig = require('../truffle.js');
var Web3 = require('web3');
var web3Location = `http://${truffleConfig.networks.development.host}:${truffleConfig.networks.development.port}`;
var provider = new Web3.providers.HttpProvider(web3Location);
web3 = new Web3(provider)
var deployAddress = web3.eth.accounts[0];


var <%= contract_name  %> = artifacts.require("./<%= contract_name %>.sol");

module.exports = function(deployer) {
  deployer.deploy(<%= contract_name  %>, <%= contract_attributes_parameter_values.join(', ').gsub('\'ADD ADDDRESS\'','deployAddress')  %>);
};
