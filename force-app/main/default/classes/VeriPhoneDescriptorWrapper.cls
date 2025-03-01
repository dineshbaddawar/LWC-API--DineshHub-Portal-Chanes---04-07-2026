public class VeriPhoneDescriptorWrapper {

    /*
     @AuraEnabled
    public String status;
    @AuraEnabled 
    Public String phone;
    @AuraEnabled
    public Boolean phone_valid;
    @AuraEnabled
    public String phone_type;
    @AuraEnabled
    public String phone_region;
    @AuraEnabled
    public String country;
    @AuraEnabled
    Public String country_code;
    @AuraEnabled
    public String country_prefix;
    @AuraEnabled
    public String international_number;
    @AuraEnabled
    public Integer local_number;
    @AuraEnabled
    public String carrier;
  */
    
    @AuraEnabled public String status;
    @AuraEnabled public Boolean phone_valid;
    @AuraEnabled public String phone_region;
    @AuraEnabled public String carrier;
    
    public VeriPhoneDescriptorWrapper parseJSON(String json){
        return (VeriPhoneDescriptorWrapper) System.JSON.deserialize(json, VeriPhoneDescriptorWrapper.class);
    }
}