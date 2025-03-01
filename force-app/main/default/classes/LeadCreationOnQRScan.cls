public without sharing class LeadCreationOnQRScan {
    
    @AuraEnabled
    Public Static string LeadCreation(string firstName,String LastName,string Phone,string Email,Id recordId){
        System.debug('firstName :'+firstName + ' && LastName :'+LastName + ' && Phone :'+Phone +  ' && Email :'+Email);
        try{                                            
            Lead ld=new Lead();
            ld.AccountId__c=recordId;
            ld.FirstName=firstName;
            ld.LastName=LastName;          
            ld.Phone=Phone;
            ld.Email=Email;
            ld.Company='Company';
            ld.Status = 'New';
            System.debug('Inserted Record Before insert :'+ld);
            insert ld;
            return ld.Name;
        }catch(Exception e){
            System.debug('The Error Message '+e.getMessage() + '&& Erron Line '+e.getLineNumber());
            system.debug('the stack track -======> ' + e.getStackTraceString());
        }
        return null;
    }
    
    @AuraEnabled
    public static Account getAccountRecord(String recordId){
        if(!String.isBlank(recordId)){
            try {
                Account acc = [SELECT Id,Name FROM Account WHERE Id=:recordId];
                System.debug('Account Record :'+acc);
                return acc;
            } catch (Exception e) {
                System.debug('Error Message :'+e.getMessage()+ ' && Error line :'+e.getLineNumber());
            }
        }
        return null;
    }
}