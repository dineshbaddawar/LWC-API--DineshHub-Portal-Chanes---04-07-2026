public class PINCodeAPI {
    
    Public Static Contact afterInsertContactPindCode(List<Contact> conList){
        System.debug('conList API ::: '+conList);
        try{
            Set<id> conIdSet = new Set<Id>();
            for(Contact con : conList){
                conIdSet.add(con.Id);
            }
            System.debug('conIdSet API ::: '+conIdSet);
            Contact con = [SELECT id,Name,MailingPostalCode FROM Contact Where Id IN:conIdSet LIMIT 1];
            System.debug('con Record API ::'+con);
            String Pincode = con.MailingPostalCode;
            if(Pincode !=null && con.Id !=null){
                PINCodeAPI.getPineCodeResponse(Pincode,con.Id);
            }
            return con;
        }catch(Exception e){
           HandleException.CreateErrorMsg('PINCodeAPI', 'afterInsertContactPindCode', e);
        }
        return null;
    } 
    
    @future (callout=true)
    public Static void getPineCodeResponse(String Pincode, String conId){
        System.debug('Pincode  API:: '+Pincode + '&& conId  API::: '+conId);
        try{
            // URL : https://api.postalpincode.in/pincode/431809 --> PINCODe
            // URL : https://api.postalpincode.in/postoffice/Dharmabad  --> POSTOFFICE
            List<PinCodeResponseWrapper> wrapList = new List<PinCodeResponseWrapper>();
            PinCodeResponseWrapper wrap = new PinCodeResponseWrapper();
            String endpoint = 'https://api.postalpincode.in/pincode/'+Pincode;
            System.debug('endpoint ::'+endpoint);
            Http http = new Http();
            HttpRequest request = new HttpRequest(); 
            request.setMethod('GET');
            request.setEndpoint(endpoint); 
            HttpResponse response ;
            response = http.send(request);
            List<String> str = new List<String>();
            if(response.getStatusCode() == 200 && response.getBody() !=null){
                String jsonResponse = response.getBody();
                System.debug('jsonResponse ::'+jsonResponse);
                List<object> PostOfficeAddressDetails = (List<object>)JSON.deserializeUntyped(jsonResponse);
                Map<string, Object> map1 = (Map<string, Object>)PostOfficeAddressDetails[0];
                system.debug('mPap ====> ' + map1);
                String logsList = (String)map1.get('Message');
                System.debug('Message :: '+logsList);
                System.debug('Office :: '+logsList);
                
                Map<string, Object> logmap = (Map<string, Object>)map1;
                System.debug('logmap --->:: '+logmap);
                List<Object> logsListOffice = (List<Object>)logmap.get('PostOffice');
                System.debug('logsListOffice Records ::'+logsListOffice);
                List<Post_Office_Details__c> postList = new List<Post_Office_Details__c>();
                for(Object animal: logsListOffice) {
                    Map<string, Object> mtv = (Map<string, Object>)animal;
                    System.debug('block Value ::'+(string) mtv.get('Block'));
                    Post_Office_Details__c po = new Post_Office_Details__c();
                    po.Block__c = (string) mtv.get('Block');
                    po.BranchType__c = (string) mtv.get('BranchType');
                    po.Circle__c = (string) mtv.get('Circle');
                    po.District__c = (string) mtv.get('District');
                    po.Division__c = (string) mtv.get('Division');
                    po.Region__c = (string) mtv.get('Region');
                    po.State__c = (string) mtv.get('State');
                    po.Country__c = (string) mtv.get('Country');
                    po.Pincode__c =  (string) mtv.get('Pincode');
                    po.Name__c = (string) mtv.get('Name');
                    po.Contact__c = conId;
                    postList.add(po);
                }
                insert postList;
                system.debug('insert PO Record Size :::'+postList.size());
            }
        }catch(Exception e){
            HandleException.CreateErrorMsg('PINCodeAPI', 'getPineCodeResponse', e);
        }
    }
    
}