public class Trigger_Helper_Classes {
    
    // If Account has related Contacts and the user tries to delete that account it throws an error "Account Can not be delete";
    
    public static String PreventAccountDeletion(List<Account> accList){
        try{
            system.debug('the accList ::'+accList);
            Set<Id> IdSet = new Set<Id>();
            for(Account acc : accList){
                IdSet.add(acc.id);
            }
            System.debug('The IdSet ::'+IdSet);
            List<Contact> conList = [SELECT Id,AccountId,Name FROM Contact WHERE AccountId IN: IdSet];
            System.debug('conList ::'+conList);
            if(conList.size()>0){
                for(Account acc : accList){
                    acc.addError('Account Can not be Deleted');
                }
            }
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            HandleException.CreateErrorMsg('Trigger_Helper_Classes', 'PreventAccountDeletion', e);
        }
        return 'FALSE';
    }
    
    // ===========================================================================================================================================================
    
    // When an Opportunity is Created on an Account, put the latest Opportunity on the Account.
    
    public Static Decimal getLatestOpportunityAmount(List<Opportunity> oppList){
        try{
            List<Account> accList = new List<Account>();
            for(Opportunity opp : oppList){
                if(opp.AccountId !=null && opp.Amount !=null){
                    Account acc = new Account();
                    acc.id = opp.accountId;
                    acc.Latest_Opportunity_Amount__c = opp.Amount;
                    accList.add(acc);
                }
            }
            if(accList.size()>0){
                update accList;
            }
            return accList[0].Latest_Opportunity_Amount__c;
        }catch(Exception e){
            HandleException.CreateErrorMsg('Trigger_Helper_Classes', 'getLatestOpportunityAmount', e);
            return null;
        }
    }
    
    // ===========================================================================================================================================================
    
    // Whenever Lead record is inserted into the database, we need to check  duplicate records using email & Phone fields.
    // If duplicate record is found, then throw an error "Duplicate Reocord Found"
    
    public Static String PreventDuplicateLeadRecord(List<Lead> leadList){
        try{
            Set<String> emailSet = new Set<String>();
            Set<String> phoneSet = new Set<String>();
            for(Lead le : leadList){
                emailSet.add(le.Email);
                phoneSet.add(le.Phone);
            }
            
            List<Lead> leadToInsert = [SELECT Id,Name,Phone,Email FROM Lead WHERE (Email IN : emailSet OR Phone IN : phoneSet) AND (Phone !=null OR Email !=null)]; 
            System.debug('the leadToInsert ::'+leadToInsert);
            for(Lead led : leadList){
                if(leadToInsert.size()>0){
                    led.addError('Duplicate Phone Or Email Found');
                } 
            }
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('Error :'+e.getMessage()+' Line ::'+e.getLineNumber());
            HandleException.CreateErrorMsg('Trigger_Helper_Classes', 'PreventDuplicateLeadRecord', e);
            return null;
        }
    }
    
    
    // ===========================================================================================================================================================
    
    //  Tagining Account on the Basis of CaseType before inserting Case Record.
    public Static void tagAccountToCase(List<Case> caseToInsert){
        List<Account> accList = [SELECT Id,Name FROM Account];
        Map<String, Account> accMap = new Map<String,Account>();
        for(Account acc : accList){
            accMap.put(acc.Name, acc);
        }
        if(!caseToInsert.isEmpty()){
            for(Case cas : caseToInsert){
                cas.AccountId = accMap.get(cas.Type).Id;
            }
        }
    }
    
    // Tagining Entitlement Process to Case on the Base of Account Record.
    public Static void TagEntitlementProcessToCaseBeforeInsert(List<Case> caseToInsert){
        List<Id> accIds = new List<Id>();
        for(Case caseNew : caseToInsert){
            if(caseNew.AccountId !=null){
                  accIds.add(caseNew.AccountId);
            }
        }
        
        List<Entitlement> EntList = [SELECT e.Id, e.AccountId, e.AssetId FROM Entitlement e WHERE e.AccountId IN : accIds];
        if(!EntList.isEmpty()){
            for(Case cas : caseToInsert){
                if(cas.EntitlementId == null && cas.AccountId !=null){
                    for(Entitlement  Ent : EntList){
                        if(Ent.AccountId  == cas.AccountId){
                        cas.EntitlementId = Ent.Id;
                        }
                    }
                }
            }
        }
        
    }
    
    // ===========================================================================================================================================================
    
}