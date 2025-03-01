public class LWCUtilityHelper {
    
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpplineItemUnderopp(string recordId){
        try{
            return [Select id,Name,OpportunityId,Opportunity.Name,ProductCode,TotalPrice,Quantity,ListPrice,UnitPrice,Product2.Name,Description  from OpportunityLineItem where OpportunityId =:recordId ];
        }catch(Exception e){
            System.debug('Error == >'+e.getlineNumber() + ' && Error Line === >'+e.getLinenumber());
        }
        return null;
    }
    
    @AuraEnabled
    public static string updateOpplineItem(List<OpportunityLineItem> updateOpplineList){
        System.debug('updateOpplineList == >'+updateOpplineList);
        try{
            upsert  updateOpplineList;
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('Error message == >'+e.getMessage() + ' Line no == >'+e.getLineNumber());
        }
        return null;
    }
    
    // Continuation method
    @AuraEnabled
    public static Object startRequest(Id recordId) {
        // Create continuation with a timeout
        Continuation cont = new Continuation(60);
        cont.continuationMethod = 'processResponse';
        
        // Set the callout endpoint URL
        cont.state = recordId; // Pass the recordId to the response
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://buff.ly/3N0BGwJ');
        
        // Add callout request to continuation
        cont.addHttpRequest(req);
        
        // Return the continuation
        return cont;
    }
    
    public static Object processResponse(List<HttpResponse> responses, Object state) {
        // Get the first response
        HttpResponse response = responses[0];
        
        // Process the response
        // You can now use the data however you like, such as updating records in Salesforce
        
        return response.getBody(); // Returning the data
    }
    
    // ================================================================================================================================
    // Method for getting Field Set for Opportunity Record for LWC Component 1.1
    @AuraEnabled
    public static List<String> getOppFieldSetList(){
        try{
            List<String> oppFieldSetList = new List<String>();
            List<Schema.FieldSetMember> FieldSetListFromOPp  = SobjectType.Opportunity.FieldSets.FiledSet_Opp.getFields();
            for(Schema.FieldSetMember fieldsToAdd : FieldSetListFromOPp){
                System.debug('Fields === >'+String.valueOf(fieldsToAdd.sobjectfield));
                oppFieldSetList.add(String.valueOf(fieldsToAdd.sobjectfield));
            }
            if(oppFieldSetList.size()>0){
                return oppFieldSetList;
            }
        }catch(Exception e){
            System.debug('The Error ::' + e.getMessage() + ' AND Error Line No :' + e.getLineNumber());
        }
        return null;
    }
    
    // ================================================================================================================================
    // Method for getting Custom Address from Account Record LWC Component 1.2
    
    @AuraEnabled
    public static Map<String, Object> getAllCustomerAddress(String recordId){
        try {
            Map<String, Object> returnWrapperMap = new Map<String, Object>();
            List<CustomerAddressWrapper> customerShippingAddressWrapper = new List<CustomerAddressWrapper>();
            List<CustomerAddressWrapper> customerBillingAddressWrapper = new List<CustomerAddressWrapper>();
            System.debug('recordId == >'+recordId);
            if(!String.isBlank(recordId)) {
                Account customerAcc = [SELECT Id, Name, BillingState, BillingStreet, BillingCountry, BillingPostalCode, BillingCity, ShippingState, ShippingStreet, ShippingCountry, ShippingCity, ShippingPostalCode, AccountSource FROM Account WHERE Id = :recordId];
                System.debug('customerAcc == >'+customerAcc);
                if(customerAcc != null && !String.isBlank(customerAcc.BillingCountry)) {
                    customerBillingAddressWrapper.add(new CustomerAddressWrapper('Billing', customerAcc.BillingStreet, customerAcc.BillingState, customerAcc.BillingCountry, customerAcc.BillingCity, customerAcc.BillingPostalCode, 'Billing', true));
                    returnWrapperMap.put('ship_selected_index', 0);
                }
                
                if(customerAcc != null && !String.isBlank(customerAcc.ShippingCountry)) {
                    customerShippingAddressWrapper.add(new CustomerAddressWrapper('Shipping', customerAcc.ShippingStreet, customerAcc.ShippingState, customerAcc.ShippingCountry, customerAcc.ShippingCity, customerAcc.ShippingPostalCode,  'Shipping', true));
                    returnWrapperMap.put('bill_selected_index', 0);
                }
                
                for(Customer_Address__c custAddress :[SELECT Id, Address__Street__s, ToLabel(Address__StateCode__s), Address__PostalCode__s,  ToLabel(Address__CountryCode__s), Address__City__s, Type__c FROM Customer_Address__c WHERE Account__c =:recordId]) {
                    if(custAddress.Type__c == 'Billing') {
                        customerBillingAddressWrapper.add(new customerAddressWrapper(custAddress.Id, custAddress.Address__Street__s, custAddress.Address__StateCode__s, custAddress.Address__CountryCode__s, custAddress.Address__City__s, custAddress.Address__PostalCode__s, custAddress.Type__c, false));
                    }else {
                        customerShippingAddressWrapper.add(new customerAddressWrapper(custAddress.Id, custAddress.Address__Street__s, custAddress.Address__StateCode__s, custAddress.Address__CountryCode__s, custAddress.Address__City__s, custAddress.Address__PostalCode__s, custAddress.Type__c, false));
                    }
                }
                returnWrapperMap.put('account', customerAcc);
                returnWrapperMap.put('customer_ship_addresses', customerShippingAddressWrapper);
                returnWrapperMap.put('customer_bill_addresses', customerBillingAddressWrapper);
                System.debug('returnWrapperMap == >'+returnWrapperMap);
            }
            return returnWrapperMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    // ================================================================================================================================
    // Method for getting Custom Address from Account Record LWC Component 1.3
    @AuraEnabled
    public static Account getAccRecord(String recordId){
        try {
            if(String.isBlank(recordId))
                return null;
            return [Select Id, Name,  BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, AccountSource, 
                    ShippingCity, ShippingCountry, ShippingPostalCode, ShippingState, ShippingStreet FROM Account where Id =:recordId];
        } catch (Exception e) {
            System.debug('Error  == >'+e.getMessage()+' && Error Line === >'+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    public static string updateOpportunityAddress(string shippingData,String billingData,String accountId,string opportunityId){
        System.debug('shippingData == >'+shippingData+' && billingData == >'+billingData+' && accountId == >'+accountId+' && opportunityId == >'+opportunityId);
        Account accBillingaddress = new Account();
        Account accShippingaddress = new Account();
        Opportunity oppRecToUpdate = new Opportunity();
        Customer_Address__c billingCustomAddress = new Customer_Address__c();
        Customer_Address__c shippingCustomAddress = new Customer_Address__c();
        try{
            if(string.isBlank(shippingData) || string.isBlank(billingData) || string.isBlank(accountId)){
                return 'Billing or Shipping Data is Missing';
            }
            if(billingData == 'Billing'){
                accBillingaddress = [SELECT id,Name,BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet FROM Account WHERE Id=:accountId];
                System.debug('accBillingaddress == >'+accBillingaddress);
            }else{
                billingCustomAddress = [SELECT Id,Name,Type__c,Address__Street__s,Address__StateCode__s,Address__PostalCode__s,Address__CountryCode__s,Address__City__s FROM Customer_Address__c WHERE Id=:billingData];
                System.debug('billingCustomAddress == >'+billingCustomAddress);
            }   
            
            if(shippingData == 'Shipping'){
                accShippingaddress = [SELECT id,Name,ShippingCity, ShippingCountry, ShippingPostalCode, ShippingState, ShippingStreet FROM Account WHERE Id=:accountId];
                System.debug('accShippingaddress == >'+accShippingaddress);
            }else{
                shippingCustomAddress = [SELECT Id,Name,Type__c,Address__Street__s,Address__StateCode__s,Address__PostalCode__s,Address__CountryCode__s,Address__City__s FROM Customer_Address__c WHERE Id=:shippingData];
                System.debug('shippingCustomAddress === >'+shippingCustomAddress);
            }
            
            if(string.isNotBlank(opportunityId)){
                oppRecToUpdate = [SELECT Id,Name,Billing_Address__Street__s,Billing_Address__City__s,Billing_Address__PostalCode__s,Billing_Address__StateCode__s,Billing_Address__CountryCode__s,Shipping_Address__Street__s,Shipping_Address__City__s,Shipping_Address__StateCode__s,Shipping_Address__PostalCode__s,Shipping_Address__CountryCode__s FROM Opportunity WHERE Id=:opportunityId];
                System.debug('oppRecToUpdate == >'+oppRecToUpdate);
                
                if(accBillingaddress.BillingCity !=null){
                    oppRecToUpdate.Billing_Address__City__s = accBillingaddress.BillingCity;   
                }else{
                    oppRecToUpdate.Billing_Address__City__s = billingCustomAddress.Address__City__s;
                }
                
                if(accBillingaddress.BillingCountry !=null){
                    //  oppRecToUpdate.Billing_Address__CountryCode__s = accBillingaddress.BillingCountry;  
                }
                
                if(accBillingaddress.BillingPostalCode !=null){
                    oppRecToUpdate.Billing_Address__PostalCode__s = accBillingaddress.BillingPostalCode;
                }else{
                    oppRecToUpdate.Billing_Address__PostalCode__s = billingCustomAddress.Address__PostalCode__s;
                }
                
                if(accBillingaddress.BillingState !=null){
                    //  oppRecToUpdate.Billing_Address__StateCode__s = accBillingaddress.BillingState;
                }
                
                if(accBillingaddress.BillingStreet !=null){
                    oppRecToUpdate.Billing_Address__Street__s = accBillingaddress.BillingStreet;
                }else{
                    oppRecToUpdate.Billing_Address__Street__s = billingCustomAddress.Address__Street__s;
                }
                
                if(accShippingaddress.ShippingStreet !=null){
                    oppRecToUpdate.Shipping_Address__Street__s = accShippingaddress.ShippingStreet;
                }else{
                    oppRecToUpdate.Shipping_Address__Street__s = shippingCustomAddress.Address__Street__s;
                }
                
                if(accShippingaddress.ShippingCity !=null){
                    oppRecToUpdate.Shipping_Address__City__s = accShippingaddress.ShippingCity;
                }else{
                    oppRecToUpdate.Shipping_Address__City__s = shippingCustomAddress.Address__City__s;
                }
                
                if(accShippingaddress.ShippingCountry !=null){
                    // oppRecToUpdate.Shipping_Address__CountryCode__s = accShippingaddress.ShippingCountry;
                }
                if(accShippingaddress.ShippingPostalCode !=null){
                    oppRecToUpdate.Shipping_Address__PostalCode__s = accShippingaddress.ShippingPostalCode;
                }else{
                    oppRecToUpdate.Shipping_Address__PostalCode__s = shippingCustomAddress.Address__PostalCode__s;
                }
                
                if(accShippingaddress.ShippingState !=null){
                    // oppRecToUpdate.Shipping_Address__StateCode__s = accShippingaddress.ShippingState;
                }
                update oppRecToUpdate;
                System.debug('oppRecToUpdate === >'+oppRecToUpdate);
                if(oppRecToUpdate !=null){
                    return 'SUCCESS';
                }
            }
            
        }catch(Exception e){
            System.debug('Error '+e.getMessage()+' && Error Line == >'+e.getLineNumber());
        }
        return 'ERROR';
    }
    
    
    public class CustomerAddressWrapper {
        @auraEnabled
        public String id;
        @auraEnabled
        public String street;
        @auraEnabled
        public String state;
        @auraEnabled
        public String country;
        @auraEnabled
        public String city;
        @auraEnabled
        public String type;
        @AuraEnabled
        public String postalCode;
        @AuraEnabled
        public Boolean checked;
        
        public CustomerAddressWrapper(String id, String street, String state, String country, String city, String postalCode, String type, Boolean checked) {
            this.id = id;
            this.street = street;
            this.state = state;
            this.country = country;
            this.city = city;
            this.postalCode = postalCode;
            this.type = type;
            this.checked = checked;
        }
    }
    
    // ================================================================================================================================
    // Method for Custom dependent Picklist using LWC
    
    @AuraEnabled(cacheable=true)
    public static String fetchDependentPicklistValues(){
        Map<String,List<Map<String,List<String>>>> MapOfDependentPicklsit = new Map<String,List<Map<String,List<String>>>>();
        for(AggregateResult ag : [select Type, Rating, Industry from Account where Type!=null and Rating!=null and Industry!=null Group By Type, Rating, Industry]){
            system.debug('ag value == >'+ag);
            Map<String,List<String>> mapOfRatingAndIndustry = new Map<String,List<String>>();
            if(mapOfRatingAndIndustry.containsKey(String.valueOf(ag.get('Rating')))){
                mapOfRatingAndIndustry.get(String.valueOf(ag.get('Rating'))).add(String.valueOf(ag.get('Industry')));
            }else{
                mapOfRatingAndIndustry.put(String.valueOf(ag.get('Rating')),new List<String>{String.valueOf(ag.get('Industry'))});
            }
            if(MapOfDependentPicklsit.containsKey(String.valueOf(ag.get('Type')))){
                MapOfDependentPicklsit.get(String.valueOf(ag.get('Type'))).add(mapOfRatingAndIndustry);
            }else{
                MapOfDependentPicklsit.put(String.valueOf(ag.get('Type')),new List<Map<String,List<String>>>{mapOfRatingAndIndustry});
            }
        }
        system.debug('MapOfDependentPicklsit == >'+MapOfDependentPicklsit);
        return JSON.serialize(MapOfDependentPicklsit);
    }
    
    // ================================================================================================================================
    // Method for getting Quote Line item Based on QuoteId
    @AuraEnabled(cacheable=true)
    public static List<QuoteLineItem> getQLIBasedOnQuoteId(string quoteId){
        List<QuoteLineItem> QliList = new List<QuoteLineItem>(); 
        try{
            if(quoteId !=null){
                QliList = [SELECT id,ListPrice,UnitPrice,Quantity,TotalPrice,QuoteId,Product2.Name,Product2.Family FROM QuoteLineItem WHERE QuoteId=:quoteId];
                if(QliList.size()>0){
                    return QliList;
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // ================================================================================================================================
    // Datatable Styling in LWC
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, AnnualRevenue, Industry, Phone from Account WHERE AnnualRevenue !=null LIMIT 10];
    }
    
    // ================================================================================================================================
    // Gettig picklist values dynamically in Lightning web component using Apex
    @AuraEnabled (Cacheable=true)
    public static List<PicklistSet> GetPicklistFieldValuesDynamically(String objectName, String fieldName)   {
        system.debug('objectName == >'+objectName+' && fieldName == >'+fieldName);
        Schema.SObjectType objectType =   getSObjectTypeFromObjectName(objectName);
        system.debug('objectType == >'+objectType);
        Schema.DescribeSObjectResult result =   objectType.getDescribe();
        Map<String, Schema.SObjectField> fields = result.fields.getMap();
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<PicklistSet> picklistValues = new List<PicklistSet>();
        for (Schema.PicklistEntry picklistVal : ple) {
            PicklistSet tempPicklist = new PicklistSet(picklistVal.getLabel(), picklistVal.getValue());
            picklistValues.add(tempPicklist);
        }
        return picklistValues;
    }
    
    public static SObjectType getSObjectTypeFromObjectName(String objectName) {
        return ((SObject) Type.forName('Schema', objectName).newInstance()).getSObjectType();
    }
    
    public class PicklistSet {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }
        public PicklistSet(String label, String value){
            this.label = label;
            this.value = value;
        }
    }
    
    //================================================================================================================================
    @AuraEnabled(Cacheable = true)
    public static List<Contact> getContacts(){
        return [SELECT Id, Name, FirstName,LastName, Phone, Email FROM Contact limit 10];
    }
    
    //================================================================================================================================
    // Method for getting All QuotelineItem based on Quote Record - CustomRelatedList-LWC
    
    @AuraEnabled(cacheable=true)
    public static List<QuoteLineItem> fetchRecords(String recordId){
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        try {  
            qliList = [SELECT Id, Product__c, Alternate_Name__c, Quantity, TotalPrice, Subtotal, UnitPrice, Item_Number__c,Description, Color__c, Note__c, Sequence_Number__c FROM QuoteLineItem
                       WHERE Product2.Name != 'output' and  QuoteId = :recordId ORDER BY  Alternate_Name__c,Sequence_Number__c  ];       
            if(qliList.size()>0){
                System.debug('Record Size == >'+qliList.size());
                return qliList;
            }        
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
        }
        return null;
    } 
    
    //================================================================================================================================
    // Method to get Get All Invoices
    @AuraEnabled(cacheable=true)
    public static Map<String,List<Invoice__c>> getAllInvoiceRecords(){
        try{
            Map<String,List<Invoice__c>> mapOfInvoiceStatus = new Map<String,List<Invoice__c>>();
            for(Invoice__c inv : [SELECT Id,Name,Status__c FROM Invoice__c LIMIT 100]){
                if(mapOfInvoiceStatus.containsKey(inv.Status__c)){
                    System.debug('Yes');
                    mapOfInvoiceStatus.get(inv.Status__c).add(inv);
                }else{
                    System.debug('No');
                    mapOfInvoiceStatus.put(inv.Status__c,new List<Invoice__c>{inv});
                }
            }
            return mapOfInvoiceStatus;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    //================================================================================================================================
    // Method to Opportunity Record with Account Type - For Opportunity Search Pagination LWC Comp
    @AuraEnabled(cacheable= true)
    public static List<Opportunity> getOpportunityList(){
        return [SELECT Id,Name,StageName,Account.Type,CloseDate FROM Opportunity LIMIT 50];
    }
    
}