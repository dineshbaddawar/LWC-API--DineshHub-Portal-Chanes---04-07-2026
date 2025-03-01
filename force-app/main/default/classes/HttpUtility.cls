public class HttpUtility {

@AuraEnabled(Cacheable=true)
    public static list<Account> getAccWithCon(){
        return [SELECT Id, Name, Phone, Rating, (SELECT Id, FirstName, LastName FROM Contacts) FROM Account];
    }
}