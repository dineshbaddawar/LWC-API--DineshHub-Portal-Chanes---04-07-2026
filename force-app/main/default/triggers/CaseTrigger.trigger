trigger CaseTrigger on Case (before insert) {

    
    List<Account> accList = [SELECt Id,Name FROM Account];
     List<String> accName = new List<String>();
    for(Account acc : accList){
        accName.add(acc.Name);
    }
 
    //List<Case> caseList = new List<Case>();
    
    for(Case ca : trigger.new){
        List<Case> opencase = [SELECt Id, Subject,AccountId FROM Case WHERE Subject LIKE '% accName%'];
        System.debug('the opnecase-------------->'+opencase);
        if(opencase.size()>0){
            Case can = new Case();
            can.AccountId = accList[0].id;
        }
    }

    
     /*  Trigger_Helper_Classes.tagAccountToCase(trigger.new);
    Trigger_Helper_Classes.TagEntitlementProcessToCaseBeforeInsert(trigger.new);
    */
    
}