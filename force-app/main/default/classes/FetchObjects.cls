public class FetchObjects {
    
    // Method for getting All Sobjects
    @auraEnabled(cacheable=true)
    public static List<String> fetchObjectsInfo(){
        try{
            Map<String,String> objectMap = new Map<String,String>();
            list<string> ListOfSobjects = new list<string>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
                String name = objTyp.getDescribe().getName();
                String label = objTyp.getDescribe().getLabel();
                if(!name.containsignorecase('history') && !name.containsignorecase('tag') && !name.containsignorecase('SBQQ__') &&
                   !name.containsignorecase('share') && !name.containsignorecase('feed') && 
                   !name.containsignorecase('group') && !name.containsignorecase('public') &&
                   !objTyp.getDescribe().isCustomSetting() && objTyp.getDescribe().isCreateable() &&
                   objTyp.getDescribe().getRecordTypeInfos().size() > 0){      
                       objectMap.put(name,label);
                       ListOfSobjects.add(label);
                   }
            }
            System.debug(objectMap);
            if(objectMap != null && objectMap.size() > 0){
                ListOfSobjects.sort(); 
                return ListOfSobjects;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // Method for getting All Fileds by Passing Object Name
  @auraEnabled(cacheable=true)
    public static List<FieldWrapper> fetchFieldsInfo(String obj) {
        List<FieldWrapper> fieldList = new List<FieldWrapper>();
        try {
            Schema.SObjectType objToken = Schema.getGlobalDescribe().get(obj);
            Map<String, Schema.SObjectField> fieldMap = objToken.getDescribe().fields.getMap();
            
            for (String apiName : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(apiName).getDescribe();
                fieldList.add(new FieldWrapper(fieldDescribe.getLabel(), apiName));
            }
        } catch (Exception e) {
            System.debug('The Error ' + e.getMessage() + ' Error Line ' + e.getLineNumber()); 
        }
        return fieldList;
    }

    public class FieldWrapper {
        @auraEnabled public String label;
        @auraEnabled public String apiName;
        public FieldWrapper(String label, String apiName) {
            this.label = label;
            this.apiName = apiName;
        }
    }
    
    // Method for Get Dynamic Query
    @auraEnabled(cacheable=true)
    public static list<sobject> fetchResult(string query){
        try{
            list<sobject> data=new list<sobject>();
            string updatedQuery = query+' Limit 10';
            List<sObject> lstOfRecords = Database.query(updatedQuery);
            if(lstOfRecords !=null){
                return lstOfRecords;   
            }
        }catch(Exception e){
            System.debug('The Error '+e.getMessage() + 'Erron Line '+e.getLineNumber()); 
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getObjectMetadata(String objectName) {
        Map<String, String> fieldLabels = new Map<String, String>();
        
        Schema.DescribeSObjectResult objectMetadata = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Map<String, Schema.SObjectField> fields = objectMetadata.fields.getMap();
        
        for (String fieldAPI : fields.keySet()) {
            fieldLabels.put(fieldAPI, fields.get(fieldAPI).getDescribe().getLabel());
        }
        
        return fieldLabels;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SObject> fetchResultNew(String query) {
        return Database.query(query);
    }
    
}