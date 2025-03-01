public class TotalContactPerAccountHelper {

    public Static void TriggerHelperMethod(List<Contact> conList){
        Set<Id> accId = new Set<Id>();
        for(Contact con : conList){
            accId.add(con.AccountId);
        }
        
        List<Contact> conListToAdd = [SELECT AccountId,Name FROM Contact WHERE AccountId IN :accId];
        Map<Id,Decimal> totalContactMap = new Map<Id,Decimal>();
        for(Contact con : conListToAdd){
            if(totalContactMap.containsKey(con.AccountId)){
                Decimal totalCon = totalContactMap.get(con.AccountId) +1;
                totalContactMap.put(con.AccountId, totalCon);
            }else{
                totalContactMap.put(con.AccountId, 1);
            }
        }
        
        List<Account> accList = new List<Account>();
        for(Id aid:totalContactMap.keyset() ){
            Account acc = new Account();
            acc.No_of_Contacts__c = totalContactMap.get(aid);
            acc.Id = aid;
            accList.add(acc);
        }
        update accList;
    }
}