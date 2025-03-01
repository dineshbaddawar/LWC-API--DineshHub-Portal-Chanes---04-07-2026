@RESTResource(urlMapping='/razorpayWebhook/*')
global without sharing class RazorpayWebhookHandler {
	 @HttpPost
    global static String webhookListener(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String body = req.requestBody.toString();

        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(body);
        Map<String,Object> m2 =  (Map<String, Object>) m.get('payload');
        Map<String,Object> m3 =  (Map<String, Object>) m2.get('payment');
        Map<String,Object> m4 =  (Map<String, Object>) m3.get('entity');
        Map<String,Object> m5 = new Map<String, Object>();

        if(m4.containsKey('captured')){
            m5 =  (Map<String, Object>) m4.get('notes');
            String recId = m5.get('policy_name').toString();
            String objName = m5.get('objectName').toString();
            String paymentCapturedFieldName = Razorpay_configuration__c.getInstance(objName).Payment_Captured_API_Field_Name__c;

                Razorpay_configuration__c rc = Razorpay_configuration__c.getInstance(objName);
            
            String query = 'Select Id,'+paymentCapturedFieldName+' From '+objName+' Where Id=:'+recId;
            
            SObject record = Database.query(query);
            record.put(paymentCapturedFieldName,true);
            update record;
        }



        return 'Success';
    }
}