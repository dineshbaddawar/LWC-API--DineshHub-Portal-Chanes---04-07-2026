@RestResource(urlMapping='/slackwebhook')
global class SlackWebhookHandler {
    @HttpPost
    global static void handleSlackWebhook() {
        RestRequest request = RestContext.request;
        String message = request.params.get('text');
        String channelId = request.params.get('channel_id');
        APIResponse APIResponseInstance =new APIResponse(request.params.get('challenge'),'success');   
        System.debug('APIResponseInstance == >'+APIResponseInstance);
        Boolean isSuccess = true;  
        String responseMessage = 'API call was successful';  
        System.debug('request.'+request.params.get('challenge'));
        
        RestResponse response = new RestResponse();
        response.addHeader('Content-Type', 'application/json');
        response.addHeader('challenge', request.params.get('challenge'));
        response.statusCode = 200;
        RestContext.response = response;
    }
    Class APIResponse{
        public String challenge;
        public String success;
        public APIResponse(String f,String s){
            challenge=f;
            success = s;
        }
    } 
}