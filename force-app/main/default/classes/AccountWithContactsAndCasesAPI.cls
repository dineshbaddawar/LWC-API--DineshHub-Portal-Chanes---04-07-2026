@RestResource(urlMapping='/accountWithContactsAndCases/*')
global with sharing class AccountWithContactsAndCasesAPI {

    @HttpGet
    global static AccountResponse getAccountWithContactsAndCases() {
        // Get the accountId from the URL
        RestRequest req = RestContext.request;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        // Query for the Account, its related Contacts, and Contacts' related Cases
        Account acc = [ SELECT Id, Name FROM Account WHERE Id='0015i00000BNt5PAAT' LIMIT 1];
        List<Contact> conList = [SELECT Id, Name, (SELECT Id, CaseNumber, Subject FROM Cases) FROM Contact WHERE Id = '0035i000009Xi6RAAS' LIMIT 1 ];

        // Construct the response object
        AccountResponse response = new AccountResponse();
        response.accountId = acc.Id;
        response.accountName = acc.Name;
        response.contacts = new List<ContactResponse>();

        for (Contact c : conList) {
            ContactResponse contactResponse = new ContactResponse();
            contactResponse.contactId = c.Id;
            contactResponse.contactName = c.Name;
            contactResponse.cases = new List<CaseResponse>();

            for (Case cs : c.Cases) {
                CaseResponse caseResponse = new CaseResponse();
                caseResponse.caseId = cs.Id;
                caseResponse.caseNumber = cs.CaseNumber;
                caseResponse.subject = cs.Subject;
                contactResponse.cases.add(caseResponse);
            }

            response.contacts.add(contactResponse);
        }

        return response;
    }

    // Classes to structure the JSON response
    global class AccountResponse {
        public String accountId;
        public String accountName;
        public List<ContactResponse> contacts;
    }

    global class ContactResponse {
        public String contactId;
        public String contactName;
        public List<CaseResponse> cases;
    }

    global class CaseResponse {
        public String caseId;
        public String caseNumber;
        public String subject;
    }
}