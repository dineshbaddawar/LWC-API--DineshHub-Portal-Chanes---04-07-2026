public class VeriPhoneController {
    //https://api.veriphone.io/v2/verify?phone=+918446557829&key=EBAE45C7AF374A92AA788AE391FCEFB6
    @AuraEnabled(cacheable=true)
    public static VeriPhoneDescriptorWrapper VerifyPhone(String phoneParam){
        try{
            String endpoint = Label.veriphoneURL + 'phone='+phoneParam+'&key='+Label.veriphoneAPIKEY;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            System.debug('request :::'+request);
            HttpResponse response = http.send(request);
            System.debug('===> Response ::c'+response.getBody());
            return new VeriPhoneDescriptorWrapper().parseJSON(response.getBody());
        }catch(Exception e){
            HandleException.CreateErrorMsg('VeriPhoneController', 'VerifyPhone', e);
        }
        return null;
    }
    
}