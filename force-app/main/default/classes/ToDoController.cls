public class ToDoController {
    @AuraEnabled
    
    public static List<To_Do__c> loadData(){
        List<To_Do__c> toDoList = [SELECT ID, Reminder_Date__c,Due_Date__c,Description__c FROM To_Do__c ORDER BY Due_Date__c ASC NULLS LAST LIMIT 10];
       
        System.debug('toDoList::'+toDoList);
        System.debug('toDoList List::'+toDoList.size());
        return toDoList;
    }

    @AuraEnabled
    public static String saveToDoRecord(To_Do__c toDoRecord,String accId){
        system.debug('accId'+accId);
        String message;
        toDoRecord.Account__c = accId;
        system.debug('toDoRecord'+toDoRecord);
        Database.SaveResult sr = Database.insert(toDoRecord, false);
        if(!sr.isSuccess()){
            for(Database.Error err : sr.getErrors()){
                message+=err.getMessage();
            }
        }
        return message;
    }
    
    
}