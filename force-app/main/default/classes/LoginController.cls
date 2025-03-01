public class LoginController {

    /*
     @RemoteAction
        public static contact loginUser(string userName, string password){
            try{
                list<contact> conRec = [select firstName,LastName,id,email from contact where email =:userName AND Id =:password limit 1];
                system.debug('conRec----'+conRec);
                if(conRec.size() > 0 ){
                    Contact Rev = new Contact();
                    Rev.Login_Hash_Code__c = Utility.generateRandomString();
                    Rev.Id = conRec[0].Id;
                    System.debug('The Hash Code Value');
                    System.debug('the Con DATA::'+Rev);
                    update Rev;
                    return Rev;
                }else{
                    return null;
                }
            }catch(exception e){
                system.debug(e.getLineNumber()+'---error Message---'+e.getMessage());
                return null;
            }   
        } */
    
    //==============================================================================================================================================
    
    
     @RemoteAction
    public static String loginUser(string userName, string password){
        try{
            List<Contact> conRec = [SELECT Name,Email,Login_Hash_Code__c FROM Contact WHERE Email =:userName AND Id =:password LIMIT  1];
            system.debug('conRec----'+conRec);
            if(conRec.size() > 0 ){
                String currentReviewId;
                String hasCode;
                currentReviewId = conRec[0].id;
                Contact Rev = new Contact();
                Rev.Login_Hash_Code__c = UtilityClass.generateRandomString();
                Rev.Id = currentReviewId;
                hasCode = String.valueOf(Contact.Login_Hash_Code__c) ;
                System.debug('The Hash Code Value');
                update Rev;
                 System.debug('The Hash Code Value '+Rev.Login_Hash_Code__c);
                return Rev.Login_Hash_Code__c;
            }else{
                return null; 
            }
        }catch(exception e){
            system.debug(e.getLineNumber()+'---error Message---'+e.getMessage());
            return null;
        }   
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
    
}