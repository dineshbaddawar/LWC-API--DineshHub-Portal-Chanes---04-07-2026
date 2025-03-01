public class CustomCRM_Controller {
    public Contact conRecord{get;set;}  
    public String conRecordString{get;set;}
    public String currentRecord{get;set;}
    public List<String> getStageNamePickList {get;set;}
    
    public CustomCRM_Controller() {
        String hashId = apexpages.currentpage().getparameters().get('id');
        System.debug('hashId === >'+hashId);
        if(!String.isBlank(hashId) && hashId !=null){
            conRecord=[SELECT Id,Name,Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =:hashId LIMIT 1];
            conRecordString=JSON.serialize(conRecord);
        }  
    }
    
    @RemoteAction
    public static Contact getAllAccounts(String hashId){
        try{
            Contact conRecord =  [SELECT Id,FirstName,LastName,Email,Name,Phone,Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c=:hashId ];
            System.debug('conRecord === >'+conRecord);
            return conRecord;
        }catch(Exception e){
            System.debug('Error ::'+e.getMessage() + ' Line Error ::'+e.getLineNumber());
        }
        return null;
    }
    
}