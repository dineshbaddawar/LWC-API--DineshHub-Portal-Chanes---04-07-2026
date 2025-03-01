// Fiding Lead Record and OwnerId by Sending Phone as JSON Body
@RestResource(urlMapping='/findLeadOwnerId/*')
global class APItoFindOwnerId {
    @HttpPost
    global Static responseWrapper findOwnerId(){
        responseWrapper responseJSON = new responseWrapper();
        try{
            System.debug('LeadList : '+RestContext.request.requestBody.toString());
            LeadDetails_client leadRec = LeadDetails_client.parse(RestContext.request.requestBody.tostring());
            System.debug('leadRec :'+leadRec.Phone);
            List<Lead> leadList = new List<Lead>();
            if(!String.isBlank(leadRec.Phone)){
                leadList = [SELECT Id, OwnerId,Phone, Email,Owner.Email,owner.UserName FROM Lead WHERE Phone =: leadRec.phone limit 1];
                System.debug('leadList---> '+leadList);
                if(!leadList.isEmpty()){
                    for(Lead Ld : leadList){
                        responseJSON.Message = 'Lead Record Found Successfully !';
                        responseJSON.success = true;
                        responseJSON.leadRecord = Ld;
                    }
                }else{
                    responseJSON.Message = 'New Lead Record Created Successfully !';
                    Lead leadRecInstance = new Lead(lastname='--',Company='--',Phone=leadRec.phone);
                    insert leadRecInstance;
                    responseJSON.success = true;
                    responseJSON.leadRecord = leadRecInstance;
                }
            } else{
                responseJSON.Message = 'Please Provide Mobile No.';
                responseJSON.success = false;
            }
        }catch(Exception e){
            HandleException.CreateErrorMsg('APItoFindOwnerId', 'findOwnerId', e);
        }
        return responseJSON;
    }
    global class responseWrapper{
        global String Message;
        global boolean success;
        global Lead leadRecord;
        global String ErrorMessage;
    }
    
    /*
JSNO Body
{
"Phone": "9098909890988"
}
*/
}