public class SendEmailHandler {
    @AuraEnabled
    public static string processEmail(String email, String Subject, String Message){
        String sMessage='';
        try{
            Lead leadName = [Select Name,Id From Lead Where Email =: email limit 1];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {email}; 
                mail.setToAddresses(toAddresses);
            mail.setSubject(Subject);
            String htmlBody = Message;
            htmlBody = htmlBody.replace('{!User.Name}', userinfo.getName());
            htmlBody = htmlBody.replace('{!Lead.Name}', leadName.Name); 
            mail.setHtmlBody(htmlBody);
            Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            sMessage='Success';
            Task tsk = new Task();
            tsk.Status = 'Completed';
            tsk.WhoId = leadName.Id;
            tsk.Description = 'Email sent to '+leadName.Name+' regarding '+Subject+' on '+dateTime.now();
            tsk.Subject = 'Email sent to '+leadName.Name+' regarding '+Subject;
            insert tsk;
        }
        catch(Exception ex){
            sMessage=ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString();
        }
        return sMessage;
    }
    @AuraEnabled
    public static emailAndEmailTemp fetchLeadDetails(String leadId){
        List<String> templateNames = new List<String>();
        List<Email_template_Name__c> emailTemplateName = new List<Email_template_Name__c>();
        List<EmailTemplate> emailTemplates = new List<EmailTemplate>();
        List<Lead> leadList = New List<lead>();
        
        try{  
            if(!string.isBlank(leadId)){
                leadList = [Select id,Email From Lead Where id =:leadId limit 1 ];
            }
            emailTemplateName = [select Template_Name__c From Email_template_Name__c];
            if(!emailTemplateName.isEmpty()){
                for(Email_template_Name__c tempName : emailTemplateName){
                    templateNames.add(tempName.Template_Name__c);
                }  
                if(!templateNames.isEmpty()){
                    emailTemplates = [SELECT Body,Description,DeveloperName,HtmlValue,Name,Subject FROM EmailTemplate WHERE Name in : templateNames];
                }
            }
            if(!leadList.isEmpty() && !emailTemplates.isEmpty() && !templateNames.isEMpty() ){
                emailAndEmailTemp wrap = new emailAndEmailTemp(leadList[0].Email, emailTemplates, templateNames,leadList[0]);
                return wrap;
            }
            return null;
        }catch(Exception ex){
            system.debug(ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString());
            return null;
        }
    }
    public class emailAndEmailTemp{
        @auraEnabled
        public String Email;
        @auraEnabled 
        public List<EmailTemplate> emailTemplateList;
        @auraEnabled
        public List<String> emailTemplateName;
        @auraEnabled
        public Lead leadRec;
       
        public emailAndEmailTemp(String Email, List<EmailTemplate> emailTemplateList,List<String> emailTemplateName, Lead leadRec){
            this.Email = Email;
            this.emailTemplateList = emailTemplateList;
            this.emailTemplateName = emailTemplateName;
            this.leadRec = leadRec;
          
        }
        
    }
}