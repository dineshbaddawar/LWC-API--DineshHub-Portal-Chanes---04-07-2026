public without sharing class LoginController {
    
    @RemoteAction
    public static String loginUser(string userName, string password){
        string response;
        try{
            Contact con = [ SELECT Id, Email, Password__c, Session_Key__c, Is_Active__c FROM Contact WHERE Email = :userName AND Password__c = :password ORDER BY CreatedDate DESC LIMIT 1 ];   
            system.debug('conRec----'+con);
            if (con == null) {
                return JSON.serialize(new Map<String, String>{
                    'status' => 'error',
                        'message' => 'No Record Found'
                        });
            }
            
            if (con.Is_Active__c == true) {
                return JSON.serialize(new Map<String, String>{
                    'status' => 'error',
                        'message' => 'User already logged in from another browser'
                        });
            }
            
            //  Create new session
            String sessionKey = UtilityClass.generateRandomString();
            
            con.Session_Key__c = sessionKey;
            con.Is_Active__c = true;
            con.Last_Access__c = System.now();
            update con;
            
            return JSON.serialize(new Map<String, String>{
                'status' => 'success',
                    'sessionKey' => sessionKey
                    });
        }catch (Exception e) {
            System.debug('Login error: ' + e.getMessage());
            return JSON.serialize(new Map<String, String>{
                'status' => 'error',
                    'message' => 'Server Error'
                    });
        }
    }
    
    @AuraEnabled
    public static String getLogOut(String sessionKey) {
        String normalizedSessionKey = sessionKey == null ? null : sessionKey.trim();
        System.debug('Logout session key: ' + normalizedSessionKey);
        try {
            if (String.isBlank(normalizedSessionKey)) {
                return 'session_not_found';
            }

            List<Contact> contacts = [
                SELECT Id, Session_Key__c, Is_Active__c, Last_Access__c
                FROM Contact
                WHERE Session_Key__c = :normalizedSessionKey
                LIMIT 1
            ];

            if (contacts.isEmpty()) {
                System.debug('No contact found for logout session key.');
                return 'session_not_found';
            }

            Contact con = contacts[0];
            con.Session_Key__c = null;
            con.Is_Active__c = false;
            con.Last_Access__c = null;
            update con;
            System.debug('Logout contact updated: ' + con.Id);
            return 'success';
        } catch (Exception e) {
            System.debug('Logout Error: ' + e.getMessage() + ' at line ' + e.getLineNumber());
            return 'error';
        }
    }
    
    @AuraEnabled
    public static Boolean validateSessionKey(String sessionKey) {
        if (String.isBlank(sessionKey)) {
            return false;
        }
        List<Contact> conList = [SELECT Id, Last_Access__c FROM Contact WHERE Session_Key__c =:sessionKey AND Is_Active__c = true LIMIT 1];
        if (conList.isEmpty()) {
            return false;
        }
        // Session Timeout (30 min)
        Integer SESSION_TIMEOUT_MIN = 30;
        if (conList[0].Last_Access__c != null &&
            conList[0].Last_Access__c.addMinutes(SESSION_TIMEOUT_MIN) < System.now()) {
                conList[0].Session_Key__c = null;
                conList[0].Is_Active__c = false;
                conList[0].Last_Access__c = null;
                update conList[0];
                system.debug('Update 1 == >'+conList[0]);
                return false;
            }
        // Refresh Last Access
        conList[0].Last_Access__c = System.now();
        update conList[0];
        system.debug('Update 2 == >'+conList[0]);
        return true;
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
        List<Component__c> lwcList = [SELECT Id,Status__c,GitHub_Repo__c,Record_URL__c,Location__c,SanpShot__c,Description__c,Comp_Class_Name__c, Name, Type__c,ORG_Name_Username__c FROM Component__c WHERE Type__c = 'LWC'];
        List<Component__c> auraList = [SELECT Id, Status__c,GitHub_Repo__c, Record_URL__c,Location__c,SanpShot__c,Description__c,Comp_Class_Name__c, Name, Type__c,ORG_Name_Username__c FROM Component__c WHERE Type__c = 'Aura' OR Type__c = 'VF Page / Aura'];
        List<Component__c> apexList = [SELECT Id, Status__c,GitHub_Repo__c, Record_URL__c,Location__c,SanpShot__c,Description__c,Comp_Class_Name__c, Name, Type__c,ORG_Name_Username__c FROM Component__c WHERE Type__c = 'Apex'];
        List<Component__c> vfList = [SELECT Id, Status__c,GitHub_Repo__c, Record_URL__c,Location__c,SanpShot__c,Description__c,Comp_Class_Name__c, Name, Type__c,ORG_Name_Username__c FROM Component__c WHERE Type__c = 'VF Page'];
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