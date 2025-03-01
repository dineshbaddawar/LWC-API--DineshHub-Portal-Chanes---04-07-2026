public class ModalPopUpController {

    @AuraEnabled
    Public Static List<Contact> fetchContactList(String accountId){
        return [SELECT Id,Name,Phone,Email FROM Contact WHERE AccountId =: accountId];
    }
}