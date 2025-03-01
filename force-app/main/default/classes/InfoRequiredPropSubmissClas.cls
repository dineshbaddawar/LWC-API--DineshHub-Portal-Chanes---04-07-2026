public class InfoRequiredPropSubmissClas {
    
    public Lead ledRec {get;set;}
    public String leadRecordString{get;set;}
    Public InfoRequiredPropSubmissClas() {
        String recordId = Apexpages.currentPage().getParameters().get('id'); 
        ledRec = [SELECT Id,Name,Address,Followup_Date__c FROM Lead WHERE ID =:recordId];
        System.debug('ledRec ::'+ledRec);
        leadRecordString=JSON.serialize(ledRec);
    }
    
    @RemoteAction
    public Static lead updateLeadData(String leadId, Lead led){
        led.Id = leadId;
        update led;
        System.debug('Lead Data ::'+led);
        return led;
    }  
}