public with sharing class CountOfContactOnAccountHelper {
   
    public static void AfterInsert(Map<Id, Contact> newMap){
        
        Set<Id> accIdSet = new Set<Id>();
        for(Contact con : newMap.Values()){
            if(con.AccountId !=null){
                accIdSet.add(con.AccountId);
                System.debug('accIdSet---->'+accIdSet);
            }
            if(accIdSet.size()>0){
                
            }
        }
    }
}