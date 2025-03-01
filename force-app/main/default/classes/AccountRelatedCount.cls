public class AccountRelatedCount {
    
    @AuraEnabled 
    public Static AccountCountWrapper getAccountcount(String recordId){
        try{
            List<Contact> conList = [SELECt Id,Name,AccountId FRoM Contact Where AccountId =:recordId];
            List<Opportunity> oppList = [SELECT Id,Name,StageName,CloseDate,AccountId FROM Opportunity where AccountId =: recordId];
            List<Case> caseList = [SELECT Id,AccountId FRoM Case Where AccountId =: recordId];
            AccountCountWrapper wrap = new AccountCountWrapper();
            wrap.contactCount = conList.size();
            wrap.OpportunityCount = oppList.size();
            wrap.caseCount = caseList.size();
            System.debug('wrap Result ::'+wrap);
            return wrap;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }        
        return null;
    }
    
    public Class AccountCountWrapper{
        @AuraEnabled public integer contactCount;
        @AuraEnabled public integer OpportunityCount;
        @AuraEnabled public integer caseCount;
    }
}