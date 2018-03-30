var <%= contract_name  %> = artifacts.require("./<%= contract_name %>.sol");

module.exports = function(deployer) {
  deployer.deploy(<%= contract_name  %>, <%= contract_attributes_parameter_values.join(', ')  %>);
};
