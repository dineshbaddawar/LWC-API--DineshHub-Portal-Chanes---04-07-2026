public  class UtilityClass {
    
    static final Integer DIGITS_PER_SET = 3;
    static final String ZERO = 'zero';
    private static Map<Integer,String> tens = new Map<Integer,String> {
        20 => 'twenty',
            30 => 'thirty',
            40 => 'forty',
            50 => 'fifty',
            60 => 'sixty',
            70 => 'seventy',
            80 => 'eighty',
            90 => 'ninety'
            };
                private static Map<Integer,String> smallNumbers = new Map<Integer,String> {
                    0 => 'zero',
                        1 => 'one',
                        2 => 'two',
                        3 => 'three',
                        4 => 'four',
                        5 => 'five',
                        6 => 'six',
                        7 => 'seven',
                        8 => 'eight',
                        9 => 'nine',
                        10 => 'ten',
                        11 => 'eleven',
                        12 => 'twelve',
                        13 => 'thirteen',
                        14 => 'fourteen',
                        15 => 'fifteen',
                        16 => 'sixteen',
                        17 => 'seventeen',
                        18 => 'eighteen',
                        19 => 'nineteen'
                        };
                            private static Map<Integer,String> modifiers = new Map<Integer,String> {
                                1 => 'thousand ',
                                    2 => 'million ',
                                    3 => 'billion '
                                    };    
                                        
                                        public static String convert(Integer value) {
                                            // zero is a special case
                                            if (value == 0)
                                                return ZERO;
                                            // text representation of the number to convert. e.g. 'one hundred'
                                            String numberText = '';
                                            // If value is negative prepend the text with 'negative'
                                            // and then process as a positive value
                                            if (value < 0) {
                                                numberText = 'negative ';
                                                value *= -1;
                                            }
                                            // string representation of the number to convert. e.g. '100'
                                            String numberString = String.valueOf(value);
                                            // split the number into sets (hundreds, thousands, millions, billions)
                                            // and convert each as a three digit number.
                                            while(numberString.length() > 0){
                                                // Figure out how many digits are in this set
                                                Integer digits = Math.mod(numberString.length(), DIGITS_PER_SET) == 0 ?
                                                    DIGITS_PER_SET :
                                                Math.mod(numberString.length(), DIGITS_PER_SET);
                                                // Create a string to represent this set.
                                                String thisSet = numberString.substring(0, digits);
                                                // Convert the set into an integer and generate the text for this set.
                                                Integer valueToConvert = Integer.valueOf(thisSet);
                                                // Remove the first set from numberString now that it has been converted.
                                                numberString = numberString.substring(digits, numberString.length());
                                                if (valueToConvert > 0) {                
                                                    String setText = generateText(valueToConvert);
                                                    // Calculate the modifierIndex to determine what set this is
                                                    // e.g. thousands, millions, billions.
                                                    Integer modifierKey = numberString.length() / DIGITS_PER_SET;
                                                    // Create the modifier string
                                                    String modifier = modifierKey > 0 ? ' ' + modifiers.get(modifierKey) : '';
                                                    // Build the text
                                                    numberText += setText + modifier;
                                                }
                                            }    
                                            System.debug('Text ::'+numberText.trim());
                                            string newtest = numberText.trim().replace('-',' ');
                                            // return numberText.trim();
                                            
                                            String upperCase = newtest.toUppercase();
                                            System.debug('upperCase ::'+upperCase);
                                            return upperCase;
                                        }
    
    private static String generateText(Integer value) {
        if (value < 100)
            return generateTextForTwoDigits(value);
        String numberText = '';
        // Calculate the number of hundreds
        Integer hundreds = value / 100;
        if (hundreds > 0)
            numberText = generateTextForTwoDigits(hundreds) + ' hundred';
        // Calculate the leftover value
        Integer leftOver = Math.mod(value, 100);
        if (leftOver > 0)
            numberText += ' ' + generateTextForTwoDigits(leftOver);
        System.debug('numberText ::'+numberText);
        return numberText;
    }
    
    private static String generateTextForTwoDigits(Integer value) {
        if (value < 20) {
            return smallNumbers.get(value);
        }
        // Round the value down to the nearest 10 and get the text representation
        Integer tensKey = (value/10) * 10;
        String numberText = tens.get(tensKey);
        // Calculate the leftover value
        Integer leftOver = value - tensKey;
        if (leftOver > 0) {
            // Add a hypen for values between 21 - 99.
            // https://www.grammarly.com/blog/hyphen-in-compound-numbers/
            if (tensKey >= 20 && tensKey <= 90 && leftOver > 0) {
                numberText += '-';
            }
            numberText += generateTextForTwoDigits(leftOver);
        }
        return numberText;
    }
    
    //=============================================================================================================================================================
    
    @AuraEnabled(cacheable=true)
    public static list<Account> getAccounts(String strName){
        String strNameLike = '%' +strName +'%';
        return [SELECT Name, AccountNumber FROM Account WHERE Name LIKE :strNameLike LIMIT 5];
    }  
    
    @AuraEnabled(cacheable=true)
    public static list<Contact> getContacts(String strName){
        String strNameLike = '%' +strName +'%';
        return [SELECT Name, Phone FROM Contact WHERE Name LIKE :strNameLike LIMIT 5];
    }   
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunity(String SearchKey){
        String searchText = '%' + SearchKey + '%';
        return [SELECT Id,Name,StageName FROM Opportunity WHERE Name LIKE : searchText];
    }
    
    //=============================================================================================================================================================
    // Aura Component  <c:GetAccountDetails/> ------- Start Here
    
    @AuraEnabled
    Public Static List<Account> getAccountDeatails(){
        return [SELECT Id,Name,Phone,Site FROM Account WHERE Type !=null AND Phone !=null LIMIT 10];
    }
    
    @AuraEnabled
    Public Static Boolean insertAccount(String accName, string accPhone,String accsite){
        Account acc = new Account();
        acc.Name= accName;
        acc.Phone = accPhone;
        acc.Site = accsite;
        insert acc;
        return true;
    }
    
    @AuraEnabled
    Public Static Account getAccountByAccId(String Id){
        return [SELECt Id,Name,Phone,Site FROM Account WHERE Id =: Id ];
    }
    
    @AuraEnabled
    public Static Boolean updateAccountRecords(String accName, String accPhone, String accSite, String accID1){
        
        Account acc = new Account();
        acc.Name = accName;
        acc.Phone = accPhone;
        acc.Site = accSite;
        acc.Id = accID1;
        update acc;        
        return true;
    }
    
    
    // End Here
    
    //=============================================================================================================================================================
    
    
    @AuraEnabled
    Public Static List<Contact> getContactDetails(){
        return [SELECT Id,FirstName,LastName,Name,Email,Phone FROM Contact LIMIT 10];
    }
    
    
    @AuraEnabled
    Public Static List<Opportunity> getOppDetails(){
        return [SELECT Id,Name,StageName,CloseDate FROM Opportunity LIMIT 10];
    }
    
    Public Static void TotalCountPrice(List<Contact> conList){
        Set<Id> accId = new Set<Id>();
        for(Contact con : conList){
            accId.add(con.AccountId);
        }
        
        List<Contact> conListToQuery = [SELECT AccountId,Con_Price__c FROM Contact WHERE AccountId IN : accId];
        Map<Id, Decimal> accPriceMap = new Map<Id,Decimal>();
        for(Contact con : conListToQuery){
            if(accPriceMap.containsKey(con.AccountId)){
                Decimal totalPrice = accPriceMap.get(con.AccountId) + con.Con_Price__c;
                accPriceMap.put(con.AccountId, totalPrice);
            }else{
                accPriceMap.put(con.AccountId, con.Con_Price__c);
            }
        }
        List<Account> accLIst = new List<Account>();
        for(Id acId : accPriceMap.keySet()){
            Account acc = new Account();
            acc.Total_Con_Price__c = accPriceMap.get(acId);
            acc.Id = acId;
            accList.add(acc);
        }
        update accList;
    }
    
    //=============================================================================================================================================================
    
    
    // Lightning Data table 
    
    @AuraEnabled
    public static List<Contact> fetchContactRecords() {
        
        return [SELECT Id, Name,LastName, Phone, Email FROM Contact LIMIT 10];
    }
    
    //=============================================================================================================================================================
    
    // Rollup Summary for Account on Contact object
    
    // After Insert
    
    public void AfterInsert(Map<Id,Contact> newMap){
        System.debug('AfterInsert Method ::newMap:: '+newMap);
        Set<id> accIds = new Set<Id>();
        for(Contact con : newMap.values()){
            if(con.AccountId !=null){
                accIds.add(con.AccountId);
                System.debug('AfterInsert Method ::accIds:: '+accIds);
            }
        }
        if(accIds.size()>0){
            this.AfterUpdate(accIds);
        }
    }
    
    
    // After Delete
    
    public void AfterDelete(Map<id,Contact> oldMap){
        System.debug('AfterDelete Method ::oldMap:: '+oldMap);
        Set<Id> accIds = new Set<Id>();
        for(Contact con : oldMap.values()){
            if(con.AccountId !=null){
                accIds.add(con.AccountId);
                System.debug('AfterDelete Method ::accIds:: '+accIds);
            }
        }
        if(accIds.size()>0){
            this.AfterUpdate(accIds);
        }
    }
    
    // After Undelete
    
    public void AfterUnDelete(Map<Id,Contact> newMap){
        System.debug('AfterUnDelete Method ::newMap:: '+newMap);
        Set<Id> accIds = new Set<Id>();
        for(Contact con : newMap.values()){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
                System.debug('AfterUnDelete Method ::accIds:: '+accIds);
            }
        }
        if(accIds.size()>0){
            this.AfterUpdate(accIds);
        }
    }
    
    // After Update
    
    public void AfterUpdate(Set<Id> accountIds){
        System.debug('AfterUpdate Method ::accountIds:: '+accountIds);
        List<Account> accList = [SELECT Id,No_of_Contacts__c,(SELECT Id FROM Contacts) FROM Account WHERE Id IN:accountIds];
        for(Account acc : accList){
            acc.No_of_Contacts__c = acc.Contacts.size();
        }
        if(accList.size()>0){
            update accList;
            System.debug('AfterUnDelete Method ::accList:: '+accList);
        }
    }
    
    //=============================================================================================================================================================
    
    // Controller to Insert Contact Record
    public Static Contact insertContact(){
        try{
            Contact con = new Contact();
            con.FirstName = 'Dinesh';
            con.Phone = '4567890';
            insert con;
            return con;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            HandleException.captureError('UtilityClass', 'insertContact',e);
            return null;
        }
    }
    
    //=============================================================================================================================================================
    
    @AuraEnabled
    public Static List<Account> senEmailToAccount(List<Account> accList){
        try{
            accList = [SELECT Id,Name,Email__c FROM Account];
            EmailTemplate temp = [Select id, Subject, Body ,HTMLValue From EmailTemplate Where Name = 'Offer Email'];
            List<Messaging.SingleEmailMessage> EmailList = new List<Messaging.SingleEmailMessage>();
            
            String subject = temp.Subject;
            String plainTextBody = temp.Body;
            for(Account con : accList){
                String htmlBody = temp.HtmlValue;
                // htmlBody = htmlBody.replace('{!Account.Name}', con.Name);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                mail.setHtmlBody(htmlBody);
                mail.setSubject(subject);
                mail.setPlainTextBody(plainTextBody);
                mail.setToAddresses(new String[] {'dinesh.butilitarianlab@gmail.com'});
                EmailList.add(mail);
            }
            if(!EmailList.isEmpty()){
                Messaging.sendEmail(EmailList);
            }
            System.debug('accList >>>>>>:'+accList);
            return accList;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    //=============================================================================================================================================================
    
    
    @AuraEnabled
    public Static void senEmailToAccountList(List<Account> accList){
        try{
            EmailTemplate templateId = [Select id,Body,Subject,HtmlValue from EmailTemplate where name = 'Offer Email'];
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<String> address = new List<String>();
            for(Account acc : accList){
                String planbody = templateId.Body;
                String subject =  templateId.Subject;
                address.add(acc.Email__c);    
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSubject(subject);
                mail.setplaintextbody(planbody);
                mail.setToAddresses(address);
                mail.setTemplateID(templateId.Id);
                emailList.add(mail);  
            }
            if(!emailList.isEmpty()){
                Messaging.sendEmail(emailList);
            }    
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
    //=============================================================================================================================================================
    // Learning Apex Code 
    
    
    // Collection Apex Class
    
    public Static void ListMethod(){
        // Add Method:
        List<String> str = new List<String>();
        str.add('Name');
        str.add('LastName');
        System.debug('The List Has---- '+str);
        
        // Clone Method:
        
        List<String> newstr = str.clone();
        System.debug('Cloned List Values ----- '+newstr);
        System.debug('Size List Values ----- '+newstr.size());
        newstr.remove(1);
        newstr.add('two');
        System.debug('After Remove List Values ----- '+newstr);
        
        List<String> str1 = newstr.clone();
        
        System.debug('the List equls---- '+newstr.equals(str1));
        System.debug('Get the Index 1 value---> '+str1.get(1));
        // Setting new value to the index
        str1.set(1, 'Salesforce CRM');
        System.debug('After Setting the new Index 1 value---> '+str1.get(1));
        str1.clear();
        System.debug('clear List Values ----- '+str1);
    }
    
    //=============================================================================================================================================================
    
    public Static void SetMethod(){
        Set<String> set1 = new Set<String>{'One','Two','Three'};
            set1.add('Salesforce');
        System.debug('the Set1 Values-- '+set1);
        // Size method
        System.debug('the Set1 Size-- '+set1.size());
        // Remove Method
        set1.remove('Salesforce');
        System.debug('the Set1 Size-- '+set1);
        // Size Method
        System.debug('the Size of Set1 ---- '+set1.size());
        // Contain Method
        boolean contain=   set1.contains('One');
        
        System.debug('contain Method ---->'+contain);
        //  isEmpty  Method
        Boolean isEmptyMethod = set1.isEmpty();
        System.debug('isEmpty  Method ---->'+isEmptyMethod);
    }
    
    //=============================================================================================================================================================
    
    public Static void MapMethod(){
        Map<Integer, String> map2 = new Map<Integer, String>{3 => 'one', 4 => 'two' .toUpperCase()};
            map2.put(1,'Dinesh');
        map2.put(2,'Ganesh');   
        System.debug('Map1 values   '+map2);
        // get(key): This method helps to find the value of a key in a map collection.
        
        Map<Integer, String> map1 = new Map<Integer, String>{1=> 'One' .toLowerCase(), 2=>'Two' .toUpperCase(), 3=>'Three' .toUpperCase(), 4=>'Four',5=>'Five',6=>'Six'};
            System.debug('map1 data---->'+map1);
        Boolean var = map1.containsKey(1);
        System.debug('the Contains Key----'+var);
        // get given key value
        String var1 = map1.get(2);
        System.debug('the Get Key Value----'+var1);
        Set<Integer> keySet = map1.keyset();
        System.debug('the Get keySet Value----'+keySet);
        System.debug('The values Set----'+map1.values());
        
        
        List<Account> ls = [select Id,Name from Account];
        System.debug('Account List ----'+ls);
        Map<Id, Account> m = new Map<Id, Account>(ls);
        System.debug('the Map Values in Account---- '+m);
        
        
        Account acc = new Account();
        acc.Name= 'ABc';
        acc.phone= '567890';
        
        Map<Integer, Account> map11 = new Map<Integer, Account> {};
            map11.put(1,acc);
        System.debug('the Map11 ----'+map11);
        
        Map<Integer, Account> map22 = map11.clone();
        System.debug('the Map2 -----------'+map22);
        
        map11.get(1).Phone ='1234567777';
        System.debug('the Map 1 AGain--------'+map11);
        boolean contain = map11.containsKey(1);
        System.debug('the Contaon Return -------------'+contain);
        
        Account valueusignkey = map11.get(1);
        System.debug('valueusignkey------------------- '+valueusignkey);
        
    }
    
    //=============================================================================================================================================================
    // Wrapper Class Example
    
    public static List<AccountContactWrapper> getDataFromWrapper(){
        List<AccountContactWrapper> wrapList = new List<AccountContactWrapper>();
        List<Account> accList = [SELECT Id,Name,(SELECT Id,Name,Email FROM Contacts) FROM Account];
        for(Account acc : accList){
            AccountContactWrapper obj = new AccountContactWrapper();
            obj.accName= acc.Name;
            obj.conList = acc.Contacts;
            obj.contactCount = acc.Contacts.size();
            wrapList.add(obj);
            System.debug('wrapList ::'+wrapList);
        }
        return wrapList;
    }
    
    public class AccountContactWrapper{
        public String accName {get;set;}
        public List<Contact> conList {get;set;}
        public Integer contactCount {get;set;}
    }
    
    //=============================================================================================================================================================
    
    // Custom Account Clone Controller for LWC
    static final String SELECT_CLAUSE = 'SELECT ';
    static final String  WHERE_CLAUSE = 'WHERE ';
    
    @AuraEnabled(cacheable=true)
    Public Static Account getFieldSetFromAccount(String accId){
        List<Schema.FieldSetMember> getFieldSet = SobjectType.Account.FieldSets.Account_FieldSet.getFields();
        List<String> ListToAddFieldSet = new List<String>();
        try {
            for(FieldSetMember FieldSet : getFieldSet){
                ListToAddFieldSet.add(String.valueOf(FieldSet.sobjectField));
            }
            String query = SELECT_CLAUSE + String.join(ListToAddFieldSet, ',');
            query += ' FROM Account '+ WHERE_CLAUSE + 'Id =:accId';
            System.debug('The Query -------------------'+query);
            return Database.query(query);
        }catch(Exception e){
            System.debug('The Error : '+e.getMessage());
            System.debug('The Error Line : '+e.getLineNumber());
        }
        return null;
    }
    
    //=============================================================================================================================================================
    
    // Controller Account Related Contacts in LWC
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAcc (id RecId){
        string query= 'SELECT Id, Name,(select id,Name,AccountId from contacts)'+
            ' FROM Account where Id = :RecId';
        return Database.query( query );
    }  
    
    //==============================================================================================================================================
    // Controller for Aura Showing Lead Related Record based on Email or Phone
    // Metho 1
    @AuraEnabled
    Public Static Lead fetchLeadData(String recId){
        System.debug('recordId--->'+recId);
        Lead leadList = [SELECT Id,Email,Name,Phone FROM Lead WHERE (Email !=null OR Phone !=null)  AND Id =: recId LIMIT 1];
        System.debug('leadList ::'+leadList);
        return leadList;
    }
    
    // Metho 1
    @AuraEnabled
    public Static List<Contact> getContactsByEmailData(String emailId, String conPhone){
        System.debug('emailId---:'+emailId+' conPhone-----> '+conPhone);
        List<Contact> conList =   [SELECT Id,Email,Name,Phone FROM Contact WHERE email =:emailId OR Phone =:conPhone  LIMIT 5];
        System.debug('conList--->'+conList[0].Email);
        System.debug('conList--->'+conList);
        return conList;
    }
    
    // Metho 3
    @AuraEnabled
    Public Static List<Opportunity> getOpportunityBEmailData(String emailId, String oppPhone){
        List<opportunity>  oppList = [SELECT Id,Email__c,Name,Phone__c FROM Opportunity WHERE (Email__c =:emailId OR Phone__c =:oppPhone) LIMIT 5];
        System.debug('oppList--->'+oppList);
        return oppList;
    }
    
    // Metho 4
    @AuraEnabled 
    Public Static List<Account> getAccountByEmailData(String emailId, String accPhone){
        List<Account> accList = [SELECT Id,Email__c,Name,Phone FROM Account WHERE (Email__c =:emailId OR Phone =:accPhone) LIMIT 5];
        System.debug('accList- Method-->'+accList);
        return accList;
    }
    
    //=============================================================================================================================================================
    // Class for Sending Email using Email Temp
    Public Static void SendEmailWithTemplate(){
        List<Contact> conList = new List<Contact>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> recipients = new List<String>();
        
        EmailTemplate et=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name = 'Reset Password Link	'];
        recipients.add(conList[0].Email);
        mail.setToAddresses(recipients);
        mail.setSenderDisplayName('Ondonte');
    }
    
    //=============================================================================================================================================================
    // Generate Randam String for Hashcode
    public static String generateRandomString(){
        Integer len = 10;
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr+string.ValueOf(system.now().getTime()); 
    }
    
    //=============================================================================================================================================================
    // HomePage Aura Comp
    // Class #1 : get All Account records
    @AuraEnabled
    public Static List<Account> getAllAccountsList(){
        List<Account> accList = [SELECT Id,Name,Site FROM Account ORDER BY SystemModStamp DESC LIMIT 15];
        return accList;
    }
    
    
    // Class #2 : Get Account Related Contact using AccountId
    @AuraEnabled
    public Static List<Contact> getAccountRelatedContacts (String AccId){
        List<Contact> conList = [SELECT Id,Name,AccountId FROM Contact WHERE AccountId =: accId];
        for(Contact con : conList){
            System.debug('Contacts Name :::'+con.Name);
        }
        return conList;
    }
    
    //=============================================================================================================================================================
    // Used in Aura Comp
    @AuraEnabled
    public static String fetchAnimals(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('callout:AnimalCreds');
        request.setMethod('GET');        
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            return response.getBody();
        }
        return null;
    }
    
    //=============================================================================================================================================================
    //
    Public Static List<Sobject> getSelectedObjectList(String objectapiNameParam,List<Sobject> sobjectList){
        List<Sobject> selectedObjectList = new List<Sobject>();
        List<Sobject> selectedObjectListToInsert = new List<Sobject>();
        
        if(objectapiNameParam == 'Contact'){
            String Query = 'SELECT Id,LastName,Email,Phone FROM '+objectapiNameParam;
            selectedObjectList = Database.query(Query);
            selectedObjectListToInsert = selectedObjectList;
        }else if(objectapiNameParam == 'Opportunity'){
            
        }
        return null;
    }
    
    //=============================================================================================================================================================
    // Used in LWC
     @AuraEnabled(cacheable=true)
    public Static List<Contact> getRelatedContactsLWC (String accountId){
        List<Contact> conList = [SELECT Id,Name,AccountId FROM Contact WHERE AccountId =: accountId];
        for(Contact con : conList){
            System.debug('Contacts Name :::'+con.Name);
        }
        return conList;
    }
}