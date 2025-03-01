public with sharing class ContactFormController {
    
    @RemoteAction
    public static String createContactRecord(String contactDatajsonString){
        String response;
        try{
            Map<String, Object> conData = (Map<String, Object>) JSON.deserializeUntyped(contactDatajsonString);
            Contact conRec = new Contact();
            conRec.FirstName = (String) conData.get('firstName') != null ? (String) conData.get('firstName') : '';
            conRec.LastName = (String) conData.get('lastName') != null ? (String) conData.get('lastName') : '';
            conRec.Phone = (String) conData.get('phone') != null ? (String) conData.get('phone') : '';
            conRec.Email = (String) conData.get('email') != null ? (String) conData.get('email') : '';
            conRec.OtherCity = (String) conData.get('city') != null ? (String) conData.get('city') : '';
            conRec.OtherState = (String) conData.get('state') != null ? (String) conData.get('state') : '';
            conRec.OtherPostalCode = (String) conData.get('pincode') != null ? (String) conData.get('pincode') : '';
            conRec.OtherCountry = 'India';
            conRec.Login_Hash_Code__c = UtilityClass.generateRandomString();
            conRec.RecordTypeId =  Schema.SObjectType.contact.getRecordTypeInfosByName().get('Portal User').getRecordTypeId();
            
            String timeStr = String.valueOf(System.now().getTime()); // Current time in milliseconds
            String timePart = timeStr.substring(timeStr.length() - 2); // Take the last 2 digits
            String namePart = conRec.FirstName.substring(0, 3).toLowerCase(); // First 3 characters of first name
            String emailPart = conRec.Email.substring(0, 3).toUpperCase(); // First 3 characters of email
            
            conRec.Password__c = namePart + emailPart + timePart;
            insert conRec;
            if(conRec != null){
                System.debug('Record == >'+conRec);
                // Call the email sending method
                System.debug('Contact Created Successfully: ' + conRec.Id);
                List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Welcome Notifications'];
                String htmlBody = temp.HTMLValue;
                String subject = temp.Subject;
                String plainTextBody = temp.body;
                
                  plainTextBody = plainTextBody.replace('{!Contact.FirstName}', conRec.FirstName);
                  plainTextBody = plainTextBody.replace('{!Contact.Email}', conRec.Email);
                  plainTextBody = plainTextBody.replace('{!Contact.Password__c}', conRec.Password__c);
                
                htmlBody = htmlBody.replace('{!Contact.FirstName}', conRec.FirstName);
                htmlBody = htmlBody.replace('{!Contact.Email}', conRec.Email);
                htmlBody = htmlBody.replace('{!Contact.Password__c}', conRec.Password__c);
                
                Messaging.SingleEmailMessage mailTemp = new Messaging.SingleEmailMessage();
                mailTemp.setHtmlBody(htmlBody);
                mailTemp.setSubject(temp.subject);
                mailTemp.setPlainTextBody(plainTextBody);
                mailTemp.toAddresses = new String[] {conRec.Email};
                    mailList.add(mailTemp);
            
            if(!mailList.isEmpty()){
                Messaging.sendEmail(mailList);
            }
               
                return response = 'SUCCESS';
            }
        }catch(Exception e){
            HandleException.CreateErrorMsg('ContactFormController', 'createContactRecord', e);
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return response = 'Error :'+e.getMessage();
        } 
        return  null;
    }
    
    // Method to send email based on Contact Id
    public static void sendEmailOnContactCreation(Id contactId) {
        System.debug('Contact ID Received for Email: ' + contactId);
        Contact conRec = [SELeCT Id,Name,Email From Contact WHERE Id=:contactId];
        system.debug(' conRec == >'+conRec);
    }
    
}