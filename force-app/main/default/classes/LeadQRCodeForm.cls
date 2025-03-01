public class LeadQRCodeForm {
    
    @AuraEnabled
    public Static Lead createLeadFromQRcode(String firstname, String lastname, String email, String phone,String company){
        try{
            Lead led = new Lead();
            led.FirstName = firstname;
            led.LastName = lastname;
            led.Email = email;
            led.Phone = phone;
            led.Company = company;
            insert led;
            System.debug('lead Record :'+led);
            return led;
        }catch(Exception e){
            System.debug('Error :'+e.getMessage() + ' && Error Line :'+e.getLineNumber());
        }
        return null;
    }
    
}