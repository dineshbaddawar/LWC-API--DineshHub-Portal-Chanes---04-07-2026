public class APIOrgUtilityClass {

   
     // It used to Send Payment Link to Record details page
     @AuraEnabled
     public static string sendPaymentLink(Id recordId){
          try {
               if(!String.isBlank(recordId)){
                    String email;
                    String phone;
                    String name;
                    Decimal amount;
                    String objectAPIName = String.valueOf(recordId.getsobjecttype());
                    Lead led = [SELECT Id,Name,Phone,Email,AnnualRevenue FROM Lead WHERE Id =: recordId];
                    if(led.Name !=null){
                         name = led.Name;
                    }
                    if(led.Phone !=null){
                        phone = led.Phone;
                    }
                    if(led.Email !=null){
                       email = led.Email;
                    }
                    if(led.Email !=null){
                         amount = led.AnnualRevenue;
                      }

                      RazorpayRequestJSONWrapper wrap = new RazorpayRequestJSONWrapper();
                      wrap.amount = amount;
                      wrap.first_min_partial_amount = amount;
                      wrap.setCustomer(name,phone,email);
                      wrap.setNotes(recordId,objectAPIName);

                      String body = JSON.serialize(wrap) ;
                      body = body.replace('currencyType', 'currency');
                      
                      System.debug('Body---' + body);
                      
                      HTTP http = new HTTP(  );
                      HttpRequest req = new HttpRequest(  );
                      
                      req.setHeader('Content-Type', 'application/json');
                      req.setEndpoint('callout:RazorPay');
                      req.setMethod('POST');
                      req.setBody(body);
                      
                      HTTPResponse res = http.send(req);
                      Map<String, Object> jsonBody = ( Map<String, Object> )Json.deserializeUntyped(res.getBody());
                
                      String jsonResponse =  res.getBody();
                      System.debug('jsonResponse ::'+jsonResponse);


                    return jsonResponse;
               }
               
          } catch (Exception e) {
               System.debug('Error Message ===> '+e.getMessage() + ' && Error Line ===> '+e.getLineNumber());
          }
          return 'ERROR';
     }

     
}