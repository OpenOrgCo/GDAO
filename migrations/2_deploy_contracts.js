//var ConvertLib = artifacts.require("./ConvertLib.sol");
var LawCorpus = artifacts.require("./LawCorpus.sol");
var Legislator = artifacts.require("./Legislator.sol");
var Law = artifacts.require("./Law.sol");
 var Proposal = artifacts.require("./Proposal.sol");
 var Voting = artifacts.require("./Voting.sol");
 var AutocraticVoting = artifacts.require("../../AutocraticVoting.sol");

// examples
//var SubstituteVoting = artifacts.require("./example/laws/SubstituteVoting.sol");

module.exports = function(deployer) {
  deployer.deploy(LawCorpus);
  deployer.deploy(Legislator);
  deployer.deploy(Law);
  deployer.deploy(Proposal);
  deployer.deploy(AutocraticVoting);
  // deployer.deploy(SubstituteVoting);
};