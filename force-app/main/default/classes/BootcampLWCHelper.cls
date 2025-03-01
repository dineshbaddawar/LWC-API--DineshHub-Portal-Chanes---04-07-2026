public class BootcampLWCHelper {

// Method to get Contact List
    @AuraEnabled
    public static List<Contact> getRecentlycreatedContactList(){
        try{
            return [SELECT Name,Email,Phone FROM Contact ORDER BY CreatedDate DESC LIMIT 10];
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
}