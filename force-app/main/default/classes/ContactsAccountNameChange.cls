public with sharing class ContactsAccountNameChange {
    public List<Contact> selContactLst;
    public String contactsIds;
    
    public ContactsAccountNameChange(ApexPages.StandardSetController cntlr){
        selContactLst = cntlr.getSelected(); //get selected records from account list view
        contactsIds = '';  
        for(Contact con : selContactLst){
            contactsIds += con.Id + ','; //build list of ids string concatenated with comma                         
        }
        contactsIds = contactsIds.removeEnd(','); 
    }
    
    public PageReference redirectToLC(){
        String returnUrl = '/lightning/cmp/c__ContactAccountNameTransefer?c__listofContacts='+contactsIds;
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    @AuraEnabled
    public Static AccountNameGroupWrapper QueryAccountName(){
        AccountNameGroupWrapper accWrap = new AccountNameGroupWrapper();
        try{
            Map<Id,Account> AssignAccountGroupMap = new Map<Id,Account>();
            List<Account> AssignAccGroup = [SELECT Id,Name FROM Account];
            system.debug('AssignAccGroup :: ' + AssignAccGroup);
            for(Account acc : AssignAccGroup){
                AssignAccountGroupMap.put(acc.id, acc);
            }
            accWrap.AssignAccountMap = AssignAccountGroupMap;
            
            ListView listviews =[SELECT Id, Name FROM ListView WHERE SobjectType = 'Contact' and name = 'All Contacts'];
            accWrap.AllContactlistView = listviews;
            return accWrap;
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage() + ' at lin number :: ' + e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    public Static String ChangeContactAccountName(List<String> ContactListId, String SelctedAccountId){
        List<Contact> conListToUpdated = [SELECT Id,Name,AccountId FROM Contact WHERE ID IN:ContactListId];
        for(Contact con : conListToUpdated){
            con.AccountId = SelctedAccountId;
        }
        update conListToUpdated;
        return 'SUCCESS';
    }
    
    public Class AccountNameGroupWrapper{
        @AuraEnabled
        public Map<Id,Account> AssignAccountMap {get;set;}
        @AuraEnabled
        public ListView AllContactlistView {get;set;}
    }
    
}