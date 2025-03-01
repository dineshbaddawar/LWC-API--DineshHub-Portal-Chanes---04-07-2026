public with sharing class ChatGPT {
  
    public static final String BaseEndURL = Label.ChatGptEndPointURL;

    @AuraEnabled
    public static String getChatGPTResult(String searchString){
        try{
            String Apikey = System.Label.chatgptApiKey;
            String seachQueryEscaped = (searchString).trim();
            System.debug('seachQueryEscaped ::'+seachQueryEscaped);
            Http http = new Http();
            String reqBody = '{"model": "text-davinci-003","prompt":"'
                +seachQueryEscaped+
                '","max_tokens": 4000,"temperature": 0,'
                +'"stream": false,"top_p": 0.5}';
            System.debug('Query---> '+seachQueryEscaped+' && Request Body --> '+reqBody);
            HttpRequest request = new HttpRequest();
            request.setEndpoint(BaseEndURL);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer '+String.escapeSingleQuotes(Apikey).trim());
            //Setting timeout to max 120 second to get whole response from Chat GPT Open API
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody(reqBody);
            HttpResponse response = http.send(request);
            // Parse the JSON response
            System.debug('Status Code ::'+response.getStatusCode());
            if(response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getBody());
                return response.getBody();
            }
            System.debug('Response From ChatGPT ::'+response.getBody());
            String jsonResponse = response.getBody();
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
            System.debug('results ::'+results);
            return response.getbody();

        }catch(Exception ex){
          HandleException.CreateErrorMsg('ChatGPT', 'getChatGPTResult', ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }
}