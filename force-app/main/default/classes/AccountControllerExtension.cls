public class AccountControllerExtension {
    // TEST CLASS
    Account acct;
    //the controller extension constructor
    public AccountControllerExtension(ApexPages.StandardController controller) {
        // Getting Account Record
        acct = (Account) controller.getRecord();
    }
    public List<Opportunity> getChildOpps() {
        return [Select Name, Amount, CloseDate, StageName From Opportunity Where AccountId =:acct.Id and (StageName ='Closed Won')];
    }
}