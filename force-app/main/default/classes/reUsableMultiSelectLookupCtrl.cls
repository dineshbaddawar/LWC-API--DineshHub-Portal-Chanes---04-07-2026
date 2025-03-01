public class reUsableMultiSelectLookupCtrl {
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
        System.debug('searchKeyWord == >'+searchKeyWord + ' && ObjectName === >'+ObjectName + ' && ExcludeitemsList '+ExcludeitemsList);
        String searchKey = '%' + searchKeyWord + '%';
        String sQuery;
        List < sObject > returnList = new List < sObject > ();
        
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        if(ObjectName=='User'){
            sQuery =  'select id, Name ,Email from ' +ObjectName + ' where Name LIKE: searchKey AND IsActive=true AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
        }else{
            sQuery =  'select id, Name ,Email from ' +ObjectName + ' where Name LIKE: searchKey  AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';  
        }
        
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}