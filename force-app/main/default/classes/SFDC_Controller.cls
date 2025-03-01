public class SFDC_Controller {
    
    // Getting Default Contact Records
    
    @AuraEnabled
    public Static List<Contact> getContactList(){
        try{
            List<Contact> conList = [SELECT Id,phone,Email,Name FROM Contact WHERE CREATEDDATE = THIS_WEEK LIMIT 10];
            System.debug('the conList ::'+conList);
            return conList;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null;
        }
        
    }
    
    // ============================================================================================================================================
    
    // Create Contact Record
    
    @AuraEnabled
    public static void insertCon(String firstName,String lastName,String phoneNo, String emailId){
        System.debug('firstName :'+firstName +' lastName :'+lastName +' phoneNo :'+phoneNo+ 'emailId :'+emailId);
        try{
            Contact con = new Contact();
            con.FirstName = firstName;
            con.LastName = lastName;
            con.Phone = phoneNo;
            con.Email = emailId;
            insert con;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        
    }
    
    // ============================================================================================================================================
    
    // Update Contact Record
    // #1
    @AuraEnabled
    public Static Contact getContactById(String conId){
        try{
            Contact con = [SELECT Id,FirstName,LastName,Phone,Email FROM Contact WHERE Id =: conId];
            return con;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null;
        }
        
    }
    
    // #2
    @AuraEnabled
    public Static Boolean UpdateContact(String firstName, String lastName, String phone, String email, String conId){
        try{
            Contact con = new Contact();
            con.id = conId;
            con.FirstName = firstName;
            con.LastName = lastName;
            con.Phone = phone;
            con.Email = email;
            update con;
            return true;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null;
        } 
    }
    
    // ============================================================================================================================================
    
    // Delete Contact
    @AuraEnabled
    public Static void DeleteContact(String conId){
        try{
            Contact con = new Contact();
            con.Id = conId;
            delete con;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
}