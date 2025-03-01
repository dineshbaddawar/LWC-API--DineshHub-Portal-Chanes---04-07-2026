global class SalesforceSourceORGAPIHelper {
    
    
    @AuraEnabled
    public static String callCreateCaseMethod(String recordId){
        try{
            if(recordId !=null){
                createAccountInTargetOrg(recordId);
                return 'SUCCESS';
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    @future(callout=true)
    global static void createAccountInTargetOrg(string reuestId){
        try{
            if(String.isNotBlank(reuestId)){
                Request__c queryReq = [SELECT Id,Name,Subject__c,Type__c,Origin__c,Description__c,Reason__c,Priority__c,Account__c,Account__r.Name,Account_Name__c FROM Request__c WHERE ID=:reuestId LIMIT 1];
                String QueryJson = JSON.serialize(queryReq);
                System.debug('QueryJson === >'+QueryJson);
                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:AuraCompORG/services/apexrest/createAccounToTargetORG/');
                req.setHeader('content-type','application/json; charset=UTF=8');
                req.setHeader('Accept','application/json'); // '{"accountName":"Shiva API","accountPhone":"8790234578"}'
                req.setBody(QueryJson);
                req.setMethod('POST');
                Http http = new Http();
                HttpResponse response = http.send(req);
                system.debug('response code::'+response.getStatusCode());
                system.debug('response body::'+response.getBody());
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    queryReq.Query_Status__c = 'Raised';
                    update queryReq;
                    System.debug('Update Record Case Raised  === >'+queryReq.Query_Status__c);
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }   
}