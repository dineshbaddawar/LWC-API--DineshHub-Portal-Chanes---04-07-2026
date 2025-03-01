/**
 * @author [Dinesh Baddawar]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2024-06-16 18:07:30
 * @modify date 2024-06-16 18:07:30
 * @desc [Apex Controller for Multiselect Lookup LWC Component ]
 */

public with sharing class lwcMultiLookupController {
    public lwcMultiLookupController() { 

    }
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value, List<String> selectedRecId) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        if(selectedRecId == null)
            selectedRecId = new List<String>();

        if(String.isNotEmpty(value)) {
            String query = 'Select Id,Name,'+fieldName+' FROM '+ObjectName+' WHERE ( Name LIKE  \'%' + value.trim() + '%\') and ID NOT IN: selectedRecId LIMIT 20';
           // String query = 'Select Id,Name,'+fieldName+' FROM '+ObjectName+' WHERE ( '+fieldName+' LIKE \'%' + value.trim() + '%\' OR Name LIKE  \'%' + value.trim() + '%\') and ID NOT IN: selectedRecId';
            system.debug(query);
            for(sObject so : Database.Query(query)) {
                String fieldvalue = (String)so.get(fieldName);
                sObjectResultList.add(new SObjectResult(fieldvalue, so.Id, (String)so.get('Name')));
            }
        }
        return sObjectResultList;
    }
    
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        @AuraEnabled
        public String name;
        
        public SObJectResult(String recNameTemp, Id recIdTemp, String name) {
            recName = recNameTemp;
            recId = recIdTemp;
            this.name = name;
        }
        public SObJectResult() {
          
        }
    }
}