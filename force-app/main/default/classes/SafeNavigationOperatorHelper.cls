public class SafeNavigationOperatorHelper {
    
    // old Method
    public Static string WithOutUseOfSaveNavigationOperator(String contactId){
       List<Contact> contacts = [SELECT Name FROM Contact WHERE Id = :contactId];
        if (contacts.size() == 0) {
            return null;
        }
        return contacts[0].Name;
    }
    
     // New Method
    public Static string WithUseOfSaveNavigationOperator(String contactId){
      return [SELECT Name FROM Contact WHERE Id = :contactId]?.Name;
    }
}