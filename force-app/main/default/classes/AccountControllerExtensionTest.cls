@isTest
public class AccountControllerExtensionTest {
    
    @isTest static void testAccountOpportunity(){    
        Account ac = new Account(Name = 'Test Account');   
        insert ac;       
        //AccountControllerExtensionVF is the Visualforce page created
        PageReference testPage = Page.AccountControllerExtensionVF; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(ac.Id));
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(ac);     
        AccountControllerExtension ext = new AccountControllerExtension(sc);         
        
        System.debug(ext.getChildOpps()); 
        List<Account> al = [Select Name from Account where Name LIKE '%Test%' LIMIT 1];
        System.assertEquals(1, al.size());
    } 
}