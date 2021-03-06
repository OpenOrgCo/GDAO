pragma solidity ^0.4.11;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/NormCorpus.sol";
import "../../contracts/GDAO.sol";
import "../../contracts/Legislator.sol";
import "../../contracts/example/norms/Autocracy.sol";
import "../../contracts/example/norms/SimpleMajorityVoting.sol";
import "../../contracts/example/norms/ReplaceVotingRule.sol";
import "../../contracts/example/proposals/DummyProposal.sol";

contract ReplaceVotingTest{
    LegislatorInterface legislator;
    ReplaceVotingRule norm;
    NormCorpus normCorpus;
    SimpleMajorityVoting newVoting;

    function beforeEach(){
      legislator = LegislatorInterface(DeployedAddresses.Legislator());
      normCorpus = NormCorpus(DeployedAddresses.NormCorpus());
      var proxy = GDAO(DeployedAddresses.GDAO());
      newVoting = new SimpleMajorityVoting(proxy);
      norm = new ReplaceVotingRule(legislator, newVoting, proxy);
      normCorpus.burnOwner();
      Legislator(legislator).burnOwner();
    }

    function testWhenSubstituteVotingIsEnacted_ThenNewVoting(){
      var proposal = new DummyProposal(norm);
      legislator.proposeNorm(proposal);
      bool result = legislator.enactNorm(proposal);
      Assert.isFalse(result, "Cant be enacted, no vote has been casted");
      Autocracy oldNorm = Autocracy(legislator.getVoting());
      oldNorm.vote(proposal);
      result = legislator.enactNorm(proposal);
      Assert.isTrue(result, "Must be enacted, voted for");
      Assert.isTrue(normCorpus.contains(norm), "New norm must be in corpus");
      norm.execute();
      Assert.isFalse(normCorpus.contains(norm), "Norm had to remove itself");
      Assert.isTrue(normCorpus.contains(newVoting), "SimpleMajorityVoting is now a norm");
      Assert.isTrue(address(legislator.getVoting())== address(newVoting), "new Voting must have been installed");
    }
}
