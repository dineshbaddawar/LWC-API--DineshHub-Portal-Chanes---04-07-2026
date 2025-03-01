public class CaseTriggerHelper {

      public static void CaseBasedOnAccountName(List<Case> caseListToInsert){
        List<Account> accList = [SELECT Id,Name FROM Account WHERE Name !=null];
        System.debug('The accList--------------->'+accList);
        List<String> accNameList = new List<String>();
        for(Account accName : accLIst){
            accNameList.add(accName.Name);
        }
        
       // List<Case> caseListToInsert = new List<Case>();
        Case ca = new Case();
        if(ca.Subject == accNameList[0]){
            ca.Status = 'New';
            ca.Origin = 'Phone'; 
            ca.AccountId = accList[0].Id;
          //  caseListToInsert.add(ca);
            System.debug('The caseListToInsert------------>'+caseListToInsert);
        }
    // update caseListToInsert;
    }
}