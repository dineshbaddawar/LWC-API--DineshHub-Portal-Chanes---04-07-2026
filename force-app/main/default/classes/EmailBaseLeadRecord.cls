public class EmailBaseLeadRecord {
    
    @AuraEnabled  
    Public static WraperForStorage getSearchRelated(String searchName){  
        WraperForStorage wrperObj = new WraperForStorage();  
        if(searchName != null && searchName != ' ') {       
            // builiding the SOSL Query  
            String searchQuery = 'FIND \'' + searchName + '\' RETURNING Account(Id,Name,Type), Contact(Id,Name,Account.Name where Account.Name =:searchName),Opportunity(Id,Name,Account.Name where Account.Name =:searchName)';  
            list<list<Sobject>> totalResults = search.query(searchQuery);  
            Account[] accList = (Account[])totalResults[0];  
            Contact[] conList = (Contact[])totalResults[1];  
            Opportunity[] oppList = (Opportunity[])totalResults[2];  
            wrperObj.acntsLst = accList;  
            wrperObj.cntsLst = conList;  
            wrperObj.OpportunitysLst = oppList;  
            System.debug('the plValues After Sort--->'+oppList);
        }   
        
        return wrperObj;   
    }  
    Public class WraperForStorage{  
        @AuraEnabled Public List<Account> acntsLst {get;set;}  
        @AuraEnabled Public List<Contact> cntsLst {get;set;}  
        @AuraEnabled Public List<Opportunity> OpportunitysLst {get;set;}  
        Public WraperForStorage(){}    
    }    
    
}