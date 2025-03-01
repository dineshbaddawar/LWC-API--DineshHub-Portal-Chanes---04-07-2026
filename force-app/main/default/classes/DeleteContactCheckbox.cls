public with sharing class DeleteContactCheckbox {
    
    public List<Contact> selContactLst;
    public String contactsIds;
    
    
    public DeleteContactCheckbox(ApexPages.StandardSetController cntlr){
        selContactLst = cntlr.getSelected(); //get selected records from account list view
        contactsIds = '';  
        for(Contact con : selContactLst){
            contactsIds += con.Id + ','; //build list of ids string concatenated with comma                         
        }
        contactsIds = contactsIds.removeEnd(','); 
    }
    
    public PageReference redirectToLC(){
        String returnUrl = '/lightning/cmp/c__DeleteContactCheckbox?c__listofContacts='+contactsIds;
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    @AuraEnabled
    public Static String DeleteSelContact(List<String> conIdSetToDel){
        try{
            System.debug('conIdSetToDel ::'+conIdSetToDel);
            
            List<String> lstString = conIdSetToDel[0].split(',');  
            System.debug('lstString ::'+lstString);
            List<Contact> conList = [SELECT Id,Name FROM Contact WHERE ID IN :lstString ];
            System.debug('conList To Delete :::'+conList);
           // delete conList;
            Database.DeleteResult[] drList = Database.delete(conList, false);
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('Error Message ::'+e.getMessage() + ' && Error Line ::'+e.getLineNumber());
        }
        return 'ERROR';
    }
}