public with sharing class RazorpayRequestJSONWrapper {
   
    public Decimal amount;
    public Decimal first_min_partial_amount;
    public Customer customer;
    public Notes notes;

    public class Customer{
        public String name;
        public String contact;
        public String email;

        Customer(String name, String contact, String email){
            this.name = name;
            this.contact = contact;
            this.email = email;
        }
    }

    public class Notes{
        public String policy_name;
        public String objectName;

        Notes(String policy_name,String objectName){
            this.policy_name = policy_name; 
            this.objectName = objectName;
        }
    }

    public void setCustomer(String name, String contact, String email){
        this.customer = new Customer(name, contact,email);
    }

    public void setNotes(String notesName,String objectName){
        this.notes = new Notes(notesName,objectName);
    }

    public RazorpayRequestJSONWrapper(){}
}