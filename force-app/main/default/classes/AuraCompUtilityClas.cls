public class AuraCompUtilityClas {
    
    
    // Dependent PickList Controller
    // Class : 1#
    @AuraEnabled
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName){
        String controllingField = contrfieldApiName.toLowerCase();
        System.debug('controllingField Value--------:'+controllingField);
        String dependentField = depfieldApiName.toLowerCase();
        System.debug('dependentField Value--------:'+dependentField);
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    
    // Class: 2#
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    //        HandleException.CreateErrorMsg('ClassName', 'MethodName', Exception);
    //        Class: 3#
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    // Class: #4
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
    
    // ==========================================================================================================================================================================
    
    //  add Sorting in Lightning Data Table
    @AuraEnabled
    public static list<Account> getAccountList(){
        try{
            List<Account> accList= [Select Id, Name, Phone, CreatedDate From Account Order By CreatedDate LIMIT 10];
            if(accList != null && accList.size()>0){
                return accList;
            }
        }Catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'getAccountList', e);
        }
        return null;
    }
    
    
    // ==========================================================================================================================================================================
    
    // DataTable with Row Add & Delete Action in Salesforce Lightning
    @AuraEnabled
    Public Static void getAccountRecords(List<Account> accList){
        insert accList;
    }
    
    // ==========================================================================================================================================================================
    
    
    // Display Radio Buttons Group In Horizontal View in Lightning Component
    @AuraEnabled
    public Static Map<String, String> getAccRatings(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Account.Rating.getDescribe();
        System.debug('fieldResult------->'+fieldResult);
        List<Schema.PicklistEntry> listPicklistValues = fieldResult.getPicklistValues();
        System.debug('listPicklistValues------->'+listPicklistValues);
        for(Schema.PicklistEntry iterator : listPicklistValues){
            options.put(iterator.getValue(), iterator.getLabel());
        }
        return options;
    }
    
    // ==========================================================================================================================================================================
    
    
    // Inline Editing Controller 
    // Calss 1
    @AuraEnabled
    Public Static List<Opportunity> getOpportunity(){
        return [SELECT Id,Name,StageName,Amount, CloseDate FROM Opportunity order by createdDate DESC  LIMIT 10];
    }
    
    // Class 2
    @AuraEnabled
    public Static Boolean updateOpportunity(List<Opportunity> oppList){
        try{
            update oppList;
            return true;
        }catch(Exception e){
            System.debug('The Error--->'+e.getMessage());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'updateOpportunity', e);
            return false;
        }
    }
    
    // ==========================================================================================================================================================================
    
    
    // Lightning Accordion
    @AuraEnabled
    public static List<Account> getAccounts(){
        try{
            List<Account> accList = new List<Account>();
            for(Account acc : [SELECT Id,Name,AccountNumber, AnnualRevenue, Description, Phone, Website FROM Account LIMIT 10]){
                accList.add(acc);
            }
            return accList;
        }catch(Exception e){
            System.debug('The Error--->'+e.getMessage());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'getAccounts', e);
            return null;
        }
    }
    
    // ==========================================================================================================================================================================
    
    // Multi Select Picklist Controller
    
    @AuraEnabled
    Public Static List<String> getPickListValues(){
        List<String> plValues = new List<String>();
        
        //Getting the object Type from object Name
        Schema.SObjectType objType = schema.getGlobalDescribe().get('Lead');
        System.debug('the objType--->'+objType);
        
        // Describing the object using its Object Type
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        System.debug('the objDescribe--->'+objDescribe);
        
        // Getting the Specific field information from field name. here we are using custom field Lead_Type__c
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Lead_Type__c').getDescribe();
        System.debug('the objFieldInfo--->'+objFieldInfo);
        
        // Get the picklist Field Values
        List<Schema.PicklistEntry> pickListValues = objFieldInfo.getPicklistValues();
        System.debug('the pickListValues--->'+pickListValues);
        
        // Adding picklist Value to the List
        for(Schema.PicklistEntry plv : pickListValues){
            plValues.add(plv.getValue());
            System.debug('the plValues Before Sort--->'+plValues);
        }
        plValues.sort();
        System.debug('the plValues After Sort--->'+plValues);
        return plValues;
    }
    
    // ==========================================================================================================================================================================
    
    // Controller Class for Add Delete Row Dynamically 
    
    @AuraEnabled
    Public Static void saveAccountList(List<Account> accList){
        insert accList;
    }
    
    // ==========================================================================================================================================================================
    
    // Add Multiple Child Records to Parent Object Controller
    
    @AuraEnabled 
    public static List<Contact> getContacts(){
        try{
            List<Contact> totalList = new List<Contact>();
            for(Contact con : [SELECT Id,Name,Email FROM Contact WHERE Email !=null LIMIT 10]){
                totalList.add(con);
            }
            return totalList;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage() +' Erron Line '+e.getLineNumber());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'getContacts', e);
        }
        return null;
    }
    
    @AuraEnabled 
    public Static void addParentAccount(String parentId, List<String> listofContactsId){
        try{
            List<Contact> listContacts = new List<Contact>();
            for(String sContactId : listofContactsId){
                Contact con = new Contact();
                con.Id = sContactId;
                con.AccountId = parentId;
                listContacts.add(con);
            }
            update listContacts;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage() +' Erron Line '+e.getLineNumber());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'addParentAccount', e);
        }
        
    }
    
    // ==========================================================================================================================================================================
    
    //  Delete Multiple Records Using Checkbox Controller
    
    @AuraEnabled
    Public Static List<Contact> fetchContact(){
        List<Contact> conList = new List<Contact>();
        List<Contact> conListToShow = [SELECT Id,FirstName,LastName,MobilePhone,Email, DepartMent FROM Contact LIMIT 10];
        for(Contact con : conListToShow){
            conList.add(con);
        }
        return conList;
    }
    
    @AuraEnabled
    public Static List<String> deleteRecords(List<String> lstRecordId){
        List<String> ErrorMsg = new List<String>();
        List<Contact> conListToDelete = [SELECT Id FROM Contact WHERE Id IN : lstRecordId];
        List<String> RecordDeletingId = new List<String>();
        Database.DeleteResult[] delRes = Database.delete(conListToDelete, false);
        for(Contact con : conListToDelete){
            RecordDeletingId.add(con.Id);
        }
        return RecordDeletingId;
        
    }
    
    // ==========================================================================================================================================================================
    
    @AuraEnabled(cacheable=true)
    Public Static Lead fetchLead(String recId){
        System.debug('recordId--->'+recId);
        List<String> leaEmailList =new List<String>();
        List<Lead> leadList = [SELECT Id,Email,Name,Phone FROM Lead WHERE (Email !=null OR Phone !=null)  AND Id =: recId];
        for(Lead led : leadList){
            leaEmailList.add(led.Email);
        }
        System.debug('leadList--->'+leadList);
        return leadList[0];
    }
    
    @AuraEnabled
    public Static List<Contact> getContactsByEmail(String emailId, String conPhone){
        System.debug('emailId---:'+emailId+' conPhone-----> '+conPhone);
        List<Contact> conList =   [SELECT Id,Email,Name,Phone FROM Contact WHERE (email =:emailId OR Phone =:conPhone)];
        System.debug('conList--->'+conList);
        
        return conList.size()> 0 ? conList : null;
    }
    
    @AuraEnabled
    Public Static List<Opportunity> getOpportunityBEmail(String emailId, String oppPhone){
        List<opportunity>  oppList = [SELECT Id,Email__c,Name,Phone__c FROM Opportunity WHERE (Email__c =:emailId OR Phone__c =:oppPhone)];
        System.debug('oppList--->'+oppList);
        return oppList;
    }
    
    @AuraEnabled 
    Public Static List<Account> getAccountByEmail(String emailId, String accPhone){
        List<Account> accList = [SELECT Id,Email__c,Name,Phone FROM Account WHERE (Email__c =:emailId OR Phone =:accPhone)];
        System.debug('accList- Method-->'+accList);
        return accList;
    }
    
    // ==========================================================================================================================================================================
    
    // Account & their related Contacts using Aura Component
    
    @AuraEnabled
    public Static Account AccountwithRelatedContacts(String accountId){
        try{
            List<Account> accList = [SELECT Id,Name,Email__c,Phone FROM Account WHERE Id =:accountId LIMIT 1] ;
            return accList[0];
        }catch(Exception e){
            System.debug('the Error ::'+e.getMessage()+' AND the Error Line ::'+e.getLineNumber());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'AccountwithRelatedContacts', e);
            return null;
        }
        
        
    }
    
    @AuraEnabled
    Public Static List<Contact> contactWithAccountId(String AccountId){
        List<Contact> conList = [SELECT Id,Email,AccountId,Phone,Name FROM Contact WHERE AccountId =: AccountId];
        return conList;
    }
    
    /* Try Catch Code
try{

}catch(Exception e){
System.debug('the Error ::'+e.getMessage()+' AND the Error Line ::'+e.getLineNumber());
}

*/
    
    // ==========================================================================================================================================================================
    
    // Delete Multiple Records Using Checkbox Controller
    
    
    @AuraEnabled
    public static List<Lead> featchLeadData() {
        //Returning list of leads.
        return [SELECT Id, Name,Company,Status,Phone,Email FROM Lead LIMIT 10];
    }
    
    @AuraEnabled
    public static void DeleteRecord(List<Lead> DeleteIds) {
        List<Lead> delacccon = new List<Lead>();
        for(Lead con : [SELECT Id, Name,Company,Status,Phone,Email FROM Lead WHERE Id IN : DeleteIds]){
            delacccon.add(con);
        }
        
        if(delacccon.size() > 0){
            Delete  delacccon;
        }
        
    }
    
    // ==========================================================================================================================================================================
    
    // Controller Class For Custom File Upload Using Aura Components
    
    @AuraEnabled
    public static Id SaveFile(Id parentId, String fileName, String base64Data, String contentType) {
        System.debug('parentId ::'+parentId);
        System.debug('fileName ::'+fileName);
        System.debug('base64Data ::'+base64Data);
        System.debug('ContentType ::'+fileName);
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            Attachment attach = new Attachment();
            attach.parentId = parentId;
            attach.Body = EncodingUtil.base64Decode(base64Data);
            attach.Name = fileName;
            attach.ContentType = contentType;
            Insert attach;
            System.debug('the Attach In LWC File ::'+attach);
            return attach.Id;
        }catch(Exception e){
            System.debug('the Error ::'+e.getMessage()+' AND the Error Line ::'+e.getLineNumber());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'SaveFile', e);
            return null;
        }
    }
    
    // ==========================================================================================================================================================================
    
    // Iterate map values in Salesforce Lightning component
    @AuraEnabled
    public static Map<String, String> FetchMapValues(){
        Map<String, String> Map1 = new Map<String, String>();
        Map1.put('IND','Virat Kohali');
        Map1.put('END','Ben Stokes');
        Map1.put('NZ','Kane Williamson');
        Map1.put('AUS','Aaron Finch');
        Map1.put('SA','Dean Elagar');
        return Map1;
    }
    
    // ==========================================================================================================================================================================
    
    // Controller for Custom Lookup 
    
    @AuraEnabled
    public Static List<SobjectResult> getResults(String ObjectName, String fieldName, String value){
        List<SobjectResult> SobjectResultList = new list<SobjectResult>();
        for(Sobject ob: Database.query('SELECT Id, '+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value+ '%\'')){
            String fieldValue = (String)ob.get(fieldName);
            System.debug('fieldValue ::'+fieldValue);
            SobjectResultList.add(new SobjectResult(fieldValue, ob.Id));
            System.debug('SobjectResultList ::'+SobjectResultList);
        }
        return SobjectResultList;
    }
    
    public Class SobjectResult{
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SobjectResult(String recNameTemp, Id recIdTemp){
            recName= recNameTemp;
            System.debug('recName ::'+recName);
            recId = recIdTemp;
            System.debug('recId ::'+recId);
        }
    }   
    
    // ====================================================================================================================================================================
    
    // Controller for Custom MultipickList Aura Component
    
    @AuraEnabled
    public Static List<String> getPickListValue(){
        List<String> picValues = new List<String>();
        // Getting object Type from object Name. 
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Plant__c');
        System.debug('objType ::'+objType);
        // Describing Sobject using its Object Type
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        System.debug('objDescribe ::'+objDescribe);
        // getting multipicklist field information 
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Plant_Use__c').getDescribe();
        System.debug('objFieldInfo ::'+objFieldInfo);
        // getting the picklist field values
        List<Schema.PicklistEntry> pickListValues = objFieldInfo.getPicklistValues();
        System.debug('pickListValues ::'+pickListValues);
        for(Schema.PicklistEntry plv : pickListValues){
            picValues.add(plv.getValue());
        }
        picValues.sort();
        return picValues;
    }
    
    // ========================================================================================================================================================================
    
    // Controller Class For Send Email Based on Contacts Gender & Contact Type whihc Related to The Account Record
    
    // Controller Class For All Contact Record Associated with that Given AccountId
    // #1
    
    @AuraEnabled
    public Static String GetContactBySendAccountId(String accountId, String gender, String conType){
        try{
            List<Account> accList = [SELECT Id,Name FROM Account WHERE Id =: accountId];
            Set<Id> accIdSet = new Set<Id>();
            for(Account acc : accList){
                accIdSet.add(acc.id);
            }
            
            List<Contact> conList = new List<Contact>();
            EmailTemplate emailTempRec = new EmailTemplate();
            conList = [SELECT Id,AccountId,Email,Phone,FirstName,Contact_Type__c,Gender__c FROM Contact WHERE Gender__c =:gender AND Contact_Type__c =: conType AND AccountId IN: accIdSet ];
            System.debug('ConList ::'+conList);
            emailTempRec=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name ='Reset Password Link'];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            for(Contact con : conList){
                con.Login_Hash_Code__c = UtilityClass.generateRandomString();
                
                List<String> recipients = new List<String>();
                recipients.add(con.Email);
                system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                String subject = emailTempRec.Subject;
                system.debug('subject==>'+subject);
                String htmlBody = emailTempRec.HtmlValue;
                System.debug('htmlBody ::'+htmlBody);
                if( con.Login_Hash_Code__c != null)
                    htmlBody = htmlBody.replace('{!Contact.Login_Hash_Code__c}', con.Login_Hash_Code__c);   
                htmlBody = htmlBody.replace('{!Contact.FirstName}', con.FirstName);
                system.debug('htmlBody==>'+htmlBody);
                mail.setSubject(subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
            update conList;
            System.debug('mails==>'+mails);
            system.debug('mails.size()==>'+mails.size());
            Messaging.sendEmail(mails);
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'GetContactBySendAccountId', e);
            return 'ERROR';
        }
    }
    
    // ==========================================================================================================================================================================
    
    
    // Controller Class for Getting PickList Values by Send ObjectName & Field Name.
    // #2
    @AuraEnabled
    public Static List<String> getPickListValuesMethod(String ObjectApi_name, String Field_Name){
        List<String> lstPickvals                        = new List<String>();
        Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name                             = targetType.newSObject();
        Schema.sObjectType sobject_type                 = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_name).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            lstPickvals.add(String.ValueOf(a.getLabel()).trim());  
        }
        System.debug('lstPickvals ::'+lstPickvals);
        return lstPickvals;
    }
    
    // ========================================================================================================================================================================
    
    // Controller For Send Email Template in Lead Record Detail Page
    // Class # 1
    
    @AuraEnabled
    Public Static String ProcessEmail(String email, String Subject, String Message){
        System.debug('email ::'+email +' Subject ::'+Subject +' Message ::'+Message);
        String Smessage = '';
        try{
            
            Lead leadName = [SELECT Id,Name,Email FROM Lead Where Email =:email LIMIT 1];
            System.debug('leadName ::'+leadName);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String [] toAddresses = new String[] {email};
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
            System.debug('task ::'+tsk);
        }catch(Exception e){
            System.debug('The Error Message ::'+e.getMessage() +'# AND The Error Line ::'+e.getLineNumber());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'ProcessEmail', e);
        }
        return Smessage;
    }
    
    
    
    @AuraEnabled
    public static emailAndEmailTemp fetchLeadDetails(String leadId){
        System.debug('leadId ::'+leadId);
        List<String> templateNames = new List<String>();
        List<Email_template_Name__c> emailTemplateName = new List<Email_template_Name__c>();
        List<EmailTemplate> emailTemplates = new List<EmailTemplate>();
        List<Lead> leadList = New List<lead>();
        
        try{  
            if(!string.isBlank(leadId)){
                leadList = [Select id,Email From Lead Where id =:leadId limit 1 ];
                System.debug('leadList ::'+leadList);
            }
            
            emailTemplateName = [select Template_Name__c From Email_template_Name__c];
            System.debug('emailTemplateName ::'+emailTemplateName);
            if(!emailTemplateName.isEmpty()){
                for(Email_template_Name__c tempName : emailTemplateName){
                    templateNames.add(tempName.Template_Name__c);
                    System.debug('templateNames List ::'+templateNames);
                }  
                if(!templateNames.isEmpty()){
                    emailTemplates = [SELECT Body,Description,DeveloperName,HtmlValue,Name,Subject FROM EmailTemplate WHERE Name in : templateNames];
                    System.debug('emailTemplates List ::'+emailTemplates);
                }
            }
            if(!leadList.isEmpty() && !emailTemplates.isEmpty() && !templateNames.isEMpty() ){
                emailAndEmailTemp wrap = new emailAndEmailTemp(leadList[0].Email, emailTemplates, templateNames,leadList[0]);
                System.debug('wrap ::'+emailTemplates);
                return wrap;
            }
            return null;
        }catch(Exception e){
            System.debug('The Error Message ::'+e.getMessage() +' # AND The Error Line ::'+e.getLineNumber());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'fetchLeadDetails', e);
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
    
    // ==========================================================================================================================================================================
    
    // Controller To Find Account Related Contact, Opportunity & Lead Record
    
    @AuraEnabled
    public Static Account getAccountRecord(String AccountIdToPass){
        Account acc = [SELECT Id,Name,Email__c,Phone FROM Account Where Id = :AccountIdToPass LIMIT 1];
        System.debug('acc Details ::'+acc);
        return acc;
    }
    
    @AuraEnabled
    public Static List<Contact> getAccountRelatedContact(String AccId){
        List<Contact> conList = [SELECT Id,Name,Email,Phone,AccountId FROM Contact WHERE AccountId =: AccId];
        System.debug('conList Details ::'+conList);
        return conList;
    }
    
    @AuraEnabled
    public Static List<Opportunity> getAccountRelatedOpportunity(String accId){
        List<Opportunity> oppList = [SELECT Id,Name,Email__c,StageName,CloseDate,AccountId FROM Opportunity WHERE AccountId =: accId ];
        System.debug('oppList Details ::'+oppList);
        return oppList;
    }
    
    @AuraEnabled
    public Static List<Lead> getOpportunityRelatedLead(String OppId){
        List<Lead> leadList = [SELECT Id,Name,Email,Opportunity__c,Company FROM Lead WHERE Opportunity__c =: OppId];
        System.debug('leadList Details ::'+leadList);
        return leadList;
    }
    
    // ============================================================================================================================================================
    
    // Controller for Lightning Loading Spinner & Account Related Contacts & Redirect to Contact Detail Page
    @AuraEnabled
    public Static List<Contact> conListDatFromApex(String accId){
        List<Contact> getConList = new List<Contact>();
        List<Contact> conLoopList = [SELECT Id,Name,Email,Phone, AccountId FROM Contact WHERE  AccountId =:accId LIMIT 10];
        for(Contact  con : conLoopList){
            if(con.id !=null){
                getConList.add(con);
            }
        }
        System.debug('getConList ::'+getConList.size());
        return getConList;
    }
    
    // ============================================================================================================================================================
    
    // Controller for RecordType Aura Component & this comp is added to the Quick Action in Lead Record Detail Page.
    // Class #1
    public static Map<Id,String> recordTypeMap {get;set;}
    
    @AuraEnabled
    public Static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordTypes = Lead.SobjectType.getDescribe().getRecordTypeInfos();
        System.debug('recordTypes ::'+recordTypes);
        recordTypeMap = new Map<Id,String>();
        for(RecordTypeInfo rt : recordTypes){
            if(rt.getName() != 'Master'){
                recordTypeMap.put(rt.getRecordTypeId(), rt.getName());
                System.debug('recordTypeMap Loop ::'+recordTypeMap);
            }
        }
        
        return recordTypeMap.values();
    }
    
    // Class #2
    @AuraEnabled
    public static Id getRecordTypeId(String recordTypeLabel){
        Id recId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        System.debug('recId  ::'+recId);
        return recId;
    }
    
    // ============================================================================================================================================================
    // Controller for Wrapper Class In Lightning Component -Inner Class, Aura Component.
    
    @AuraEnabled
    public Static wrapperClass getDataFromWrapper(){
        wrapperClass wrap = new wrapperClass();
        wrap.conList = [SELECT Id,Name,Phone,Email FROM Contact WHERE Email !=null AND Phone !=null LIMIT 10];
        wrap.contactCount = wrap.conList.size();
        wrap.message = 'Wrapper Class in  Aura Comp';
        return wrap;
    }
    
    public class wrapperClass{
        @AuraEnabled
        public List<Contact> conList {get;set;}
        @AuraEnabled
        public Integer contactCount {get;set;}
        @AuraEnabled
        public String message {get;set;}
    }
    
    // ============================================================================================================================================================
    // Display data from inner SOQL Query in lightning component
    @AuraEnabled
    public Static List<Account> getAccountRelatedContactList(){
        List<Account> accList = [SELECT Id,Name,(SELECT Id,Name FROM Contacts) FROM Account LIMIT 10];
        return accList;
    }
    
    // ============================================================================================================================================================
    // Controller for Fetch Picklist value from sObject and Set in ui:inputSelect 
    
    @AuraEnabled
    public Static List<String> getPicklitValueFromSobject(Sobject objObject , String fld){
        system.debug('objObject --->' + objObject);
        system.debug('fieldName --->' + fld);
        try{
            List<String> allPickValues = new List<String>();
            Schema.SObjectType SobjType = objObject.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = SobjType.getDescribe();
            Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            List<Schema.PicklistEntry> pickListValues =  fieldMap.get(fld).getDescribe().getPickListValues();
            for(Schema.PicklistEntry pic : pickListValues){
                allPickValues.add(pic.getValue());
            }
            System.debug('allPickValues ::'+allPickValues);
            allPickValues.sort();
            return allPickValues;
        }catch(Exception e){
            System.debug('The Error Message ::'+e.getMessage() +'# AND The Error Line ::'+e.getLineNumber());
            HandleException.CreateErrorMsg('AuraCompUtilityClas', 'getPicklitValueFromSobject', e);
        }
        return null;
    }
    
    // ============================================================================================================================================================
    
    @AuraEnabled
    public Static List<String> getAllFieldsOfSobject(String SobjectApiName){
        List<String> getAllFieldslist = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset() )
        {
            //  system.debug('fieldName->>'+fieldName); // This will give you the api name of the field name.
            getAllFieldslist.add(fieldName);
        }
        for(String field : getAllFieldslist){
            System.debug('field In String ---> '+field);
        }
        return getAllFieldslist;
    }
    
    // ============================================================================================================================================================
    
    @AuraEnabled
    public Static WrapperAccount getAccountRelatedRecordCounts(String recordId){
        List<WrapperAccount> wrapList = new List<WrapperAccount>();
        List<Contact> conList = [SELECt Id,Name,Email,Phone FROM Contact WHERE AccountId=:recordId];
        List<Opportunity> oppList = [SELECT Id,Name,CloseDate,StageName FROM Opportunity WHERE AccountId =:recordId];
        List<Case> caseList = [SELECT Id,CaseNumber,Status,Priority,Type,AccountId  FROM Case WHERE AccountId =:recordId];
        List<Lead> ledList = [SELECT Id,Name,Company,Phone,Email FROM Lead WHERE AccountId__c =:recordId];
        WrapperAccount wrap = new WrapperAccount();
        wrap.conList = conList;
        wrap.contactCount =conList.size();
        wrap.oppList = oppList;
        wrap.opportunityCount =oppList.size();
        wrap.caseList = caseList;
        wrap.caseCount =caseList.size();
        wrap.leadList = ledList;
        wrap.leadCount = ledList.size();
        System.debug('Wrap ::'+wrap);
        return wrap;
    }
    
    public class WrapperAccount{
        @AuraEnabled
        public List<Contact> conList {get;set;}
        @AuraEnabled
        public Integer contactCount {get;set;}
        @AuraEnabled
        public List<Opportunity> oppList {get;set;}
        @AuraEnabled
        public Integer opportunityCount {get;set;}
        @AuraEnabled
        public List<Case> caseList {get;set;}
        @AuraEnabled
        public Integer caseCount {get;set;}
        @AuraEnabled
        public List<Lead> leadList {get;set;}
        @AuraEnabled
        public Integer leadCount {get;set;}
    }
    
    // ============================================================================================================================================================
    
    @AuraEnabled
    public Static List<Contact> getAccountontactCheckbox (String recordId){
        List<Contact> conList = [SELECt Id,Name,Phone,Email FROM Contact WHERE AccountId =:recordId LIMIT 2];
        System.debug('contactList related to Account :'+conList);
        List<contentDocument> docList = [Select id,Title,FileType,CreatedBy.Name,ContentSize From contentDocument LIMIT 2];       
        System.debug('conList :::'+conList);
        return conList;
    }
    
    @AuraEnabled
    public static string getAttachmentId(string contactId){
        String attachementId  =  [SELECT Id, Name FROM Attachment WHERE ParentID =: contactId Order by LastModifiedDate desc LIMIT 1].Id;
        System.debug('attachementId == >'+attachementId);
        return attachementId;
    }
    
    //  ============================================================================================================================================================
    // Custom File Upload Using Aura Component
    
    @AuraEnabled
    public static Attachment SaveAttachement(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment attach = new Attachment();
        attach.parentId = parentId;
        attach.Body = EncodingUtil.base64Decode(base64Data);
        attach.Name = fileName;
        attach.ContentType = contentType;
        Insert attach;
        System.debug('Attachment ID ::'+attach);
        return attach;
    }
    
    @AuraEnabled
    public Static Contact getcurrentRecordDetails(String recordId){
        return [SELECt Id,Name,Email FROM Contact WHERE Id=:recordId LIMIT 1];
    }
    
    // ============================================================================================================================================================
    @AuraEnabled
    public Static List<Product2> getAllProudcts(){
        List<Product2> getProductList = [SELECT Id,Name,ProductCode,Family,Description,Product_UniqueCode__c,Product_UOM__c,QuantityUnitOfMeasure,Type FROM Product2 WHERE Family !=null LIMIT 10 ];
        return getProductList;
    }
    
    // ============================================================================================================================================================
    
    // File Upload using Aura Component
    @AuraEnabled
    public static Id SaveFileAuraComp(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment attach = new Attachment();
        attach.parentId = parentId;
        attach.Body = EncodingUtil.base64Decode(base64Data);
        attach.Name = fileName;
        attach.ContentType = contentType;
        Insert attach;
        return attach.Id;
    }
    
    // ============================================================================================================================================================
    // Dynamic Component for Sobject Type Which will Work on RecordId;
    
}