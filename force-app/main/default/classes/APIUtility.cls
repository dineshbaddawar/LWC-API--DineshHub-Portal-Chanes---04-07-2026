public class APIUtility {
    
    // Controller API Using Name Creditional
    @AuraEnabled
    public static String fetchAnimals(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        // Provide the Named Credentials
        request.setEndpoint('callout:AnimalCreds');
        request.setMethod('GET');        
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            System.debug('Response  :'+response.getBody());
            return response.getBody();
        }
        return null;
    }
    
    //===============================================================================================================================================
    
    public Static Lead GetleadReocords(){
        User us = [SELECT Id,Name FROM User WHERE Name = 'Jarvis'];
        Lead led = new Lead();
        led.OwnerId =us.Id;
        insert led;
        return led;
    }
    
    //===============================================================================================================================================
    
    // Indeed API Class
    public static String getAccesstokenOfIndeed(){
        try{
            String client_id = 'e059872c972804019917b983c4390297e816ee2a6f6740834ea13d14955fc1cb';
            String client_secret = 'EGYcuV8AabNu9V1tSnXVvf6uqjmvtlFbxmNupDqxO0DhFcP8aIAB0FuOK9iLwfjT';
            String endpoint = 'https://apis.indeed.com/oauth/v2/tokens';
            String Body = 'client_id='+EncodingUtil.urlEncode(client_id,'UTF-8')+'&client_secret='+EncodingUtil.urlEncode(client_secret,'UTF-8')+'&grant_type='+EncodingUtil.urlEncode('client_credentials','UTF-8')+'&scope=employer_access';
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setHeader('Accept', 'application/json');
            request.setBody(Body);
            System.debug('request :::'+request);
            HttpResponse response = http.send(request);
            String jsonResponse = response.getBody();
            object PostOfficeAddressDetails = (object)JSON.deserializeUntyped(jsonResponse);
            Map<string, Object> map1 = (Map<string, Object>)PostOfficeAddressDetails;
            String accessToken = (String)map1.get('access_token');
            system.debug('accessToken ====> ' + accessToken);
            return response.getBody();
        }catch(Exception e){
            System.debug('Error Message :'+e.getMessage() + ' && Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // Get All Employers Details
    
    public Static String getEmployeeDetails(String accesstoken){
        try{
            String endpoint = 'https://secure.indeed.com/v2/api/appinfo';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            return null;
        }catch(Exception e){
            System.debug('Error Message :'+e.getMessage() + ' && Error Line No :'+e.getLineNumber());
        }
        return null;
    }
}