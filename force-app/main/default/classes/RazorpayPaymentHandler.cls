global without sharing class RazorpayPaymentHandler {
    global static String sendPaymentLink(Id recordId){
        
        try{
            String objName = recordId.getSObjectType().getDescribe().getName();
        
            Razorpay_configuration__c rc = getRazorpayConfig(objName);
            
            String emailField = rc.Email_API_Field__c;
            String nameField = rc.Name_API_Field__c;
            String contactField = rc.Phone_API_Field__c;
            String amountField = rc.Amount_API_Field__c;
            String pIFieldName = rc.Payment_Initiated_API_Field__c;
            
            String query = 'Select Id,'+nameField+','+emailField+','+contactField+','+amountField+' From '+objName+' where Id=:'+recordId;
            
            SObject record = Database.query(query);
            
            String email = (String) record.get(emailField);
            String contact = (String) record.get(contactField);
            String name = (String) record.get(nameField);
            Decimal amount = (Decimal) record.get(amountField);
            
            
            if(String.isEmpty(email)){
                return 'Email is empty';
            }
            
            if(String.isEmpty(contact)){
                return 'Phone is empty';
            }
            
            if(amount == null){
                return 'Please enter the amount';
            }
            
            RazorpayRequestJSON razorpayRequestJSON = new RazorpayRequestJSON();

            razorpayRequestJSON.amount = amount;
            razorpayRequestJSON.first_min_partial_amount = amount;
            razorpayRequestJSON.setCustomer(name,contact,email);
            razorpayRequestJSON.setNotes(recordId,recordId);
            
            String body = JSON.serialize(razorpayRequestJSON);
            body = body.replace('currencyType','currency');
            
            System.debug('Body---'+body);
            
            HTTP http = new HTTP();
            HttpRequest req = new HttpRequest();
            
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint('callout:RazorPay');
            req.setMethod('POST');
            req.setBody(body);
            
            HTTPResponse res = http.send(req);
            Map<String,Object> jsonBody = (Map<String,Object>) Json.deserializeUntyped(res.getBody());
            
            System.debug('RESPPPP'+jsonBody);
            
            updateRecord(objName,pIFieldName,recordId);
            return 'Success';
            
        }catch(Exception e){
            HandleBusinessException.captureError('RazorpayPaymentHandler','sendPaymentLink',e);
            return e.getMessage();
        }
    }
    
    global static void updateRecord(String objName,String pIFieldName,Id recordId){
        String query = 'Select Id,'+pIFieldName+' From '+objName+' Where Id=:'+recordId;
            
        SObject record = Database.query(query);
        record.put(pIFieldName,true);
        update record;
    }
    
    global static Razorpay_configuration__c getRazorpayConfig(String objName){
        Razorpay_configuration__c rc = Razorpay_configuration__c.getInstance(objName);
        return rc;
    }
}