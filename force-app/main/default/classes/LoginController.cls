public class LoginController {
    
    @RemoteAction
    public static String loginUser(string userName, string password){
        try{
            List<Contact> conRec = [SELECT Name,Email,Login_Hash_Code__c,Password__c FROM Contact WHERE Email =:userName AND Password__c =:password Order By CreatedDate DESC LIMIT  1];
            system.debug('conRec----'+conRec);
            if(conRec.size() > 0 ){
                String currentReviewId;
                String newHashCode;
                currentReviewId = conRec[0].id;
                Contact Rev = new Contact(); 
                Rev.Login_Hash_Code__c = UtilityClass.generateRandomString();
                Rev.Id = currentReviewId;
                update Rev;
                System.debug('Updated Rev ==> '+Rev );
                newHashCode = String.valueOf(Rev.Login_Hash_Code__c);
                return JSON.serialize(new Map<String, String>{
                    'status' => 'success',
                    'hashCode' => newHashCode
                    });
            } else {
                return JSON.serialize(new Map<String, String>{
                    'status' => 'error',
                    'message' => 'No Record Found'
                    });
            }
        }catch(exception e){
            system.debug(e.getLineNumber()+'---error Message---'+e.getMessage());
        }   
        return null;
    }
    
    //==============================================================================================================================================
    
    // Forgot Reset Application Portal
    @RemoteAction
    Public Static String ForgotPassapplication(String emailId){
        try{
            List<Contact> conList = [SELECT Name,Email, Login_Hash_Code__c FROM Contact WHERE Email =: emailId];
            if(conList.size()>0){
                String currentConId;
                String hasCode;
                currentConId = conList[0].id;
                Contact con = new Contact();
                con.Login_Hash_Code__c = UtilityClass.generateRandomString();
                con.Id = currentConId;
                hasCode = String.valueOf(con.Login_Hash_Code__c);
                
                List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                EmailTemplate temp = [SELECT Id,Name,HTMLValue,Subject, Body FROM EmailTemplate WHERE Name = 'Application Forget Password'];
                String htmlBody = temp.HTMLValue;
                String subject = temp.Subject;
                String plainTextBody = temp.body;
                
                htmlBody = htmlBody.replace('{!Contact.Name}', conList[0].Name);
                htmlBody = htmlBody.replace('{!Contact.Login_Hash_Code__c}', con.Login_Hash_Code__c);
                //  htmlBody = htmlBody.replace('{!$Label.ApplicationPasswordReset}', Label.ApplicationPasswordReset);
                String comingEmail =  conList[0].Email;
                System.debug('comingEmail--------->'+comingEmail);
                
                Messaging.SingleEmailMessage mailTemp = new Messaging.SingleEmailMessage();
                mailTemp.setHtmlBody(htmlBody);
                mailTemp.setSubject(subject);
                mailTemp.setPlainTextBody(plainTextBody);
                mailTemp.toAddresses = new String[] { conList[0].Email };
                    mailList.add(mailTemp);
                
                if(!mailList.isEmpty()){
                    Messaging.sendEmail(mailList);
                }
                update con;
                return con.Login_Hash_Code__c;
            }
            
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
            return null;
        }
        return null;
    }
    
    // Password Reset Application Portal
    @RemoteAction
    Public Static String ApplicationPasswordReset(String password, String loginhashcode){
        try{
            Contact conToUpdate = [SELECT Name,Email, Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =: loginhashcode LIMIT 1];
            //  conToUpdate.Password__c = password;
            conToUpdate.Login_Hash_Code__c = UtilityClass.generateRandomString();
            update conToUpdate;
            return conToUpdate.Login_Hash_Code__c;
        }catch(Exception e){
            System.debug('The Error---->'+e.getMessage());
            System.debug('The Error Line---->'+e.getLineNumber());
        }
        return null;
    }

    @AuraEnabled
    public static string getLogOut(String hashcode){
        System.debug('hashcode === >'+hashcode);
        try {
            String response;
            // On Logout remove the hash code from the contact
            Contact conToUpdate = [SELECT Id,Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =: hashcode LIMIT 1];
              System.debug('conToUpdate === >'+conToUpdate);
            if(conToUpdate != null){
            conToUpdate.Login_Hash_Code__c = '';
            update conToUpdate;
            response = 'success';
            }else{
             response = 'No Record Found !';
            }
            return response;
        } catch (Exception e) {
            system.debug('Error ==>'+e.getMessage()+' && Error Line ==>'+e.getLineNumber());
        }
        return null;
    }

    @AuraEnabled
    public static String getContactHashCode(String hashcode) {
        System.debug('hashcode=== >'+hashcode);
        try {
            // Query to fetch the contact with the given hashcode
            Contact con = [SELECT Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c = :hashcode LIMIT 1];
            System.debug('con === >'+con);
            return con.Login_Hash_Code__c;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return null;
    }


    @AuraEnabled(cacheable=true)
    public static compWrapper getComponentList() {
        compWrapper wrapper = new compWrapper();
        List<Component__c> lwcList = [SELECT Id, Name, Type__c FROM Component__c WHERE Type__c = 'LWC'];
        List<Component__c> auraList = [SELECT Id, Name, Type__c FROM Component__c WHERE Type__c = 'Aura'];
        List<Component__c> apexList = [SELECT Id, Name, Type__c FROM Component__c WHERE Type__c = 'Apex'];
        List<Component__c> vfList = [SELECT Id, Name, Type__c FROM Component__c WHERE Type__c = 'VF Page'];
        wrapper.lwcList = lwcList;
        wrapper.auraList = auraList;
        wrapper.apexList = apexList;
        wrapper.vfList = vfList;
        System.debug('wrapper === >'+wrapper);
        return wrapper;
    }
    
    public class compWrapper{
        @AuraEnabled 
        public  list<Component__c> lwcList;
        @AuraEnabled
        public   list<Component__c> auraList ;
        @AuraEnabled 
        public  list<Component__c> apexList;
        @AuraEnabled
        public  list<Component__c> vfList;
    }
}