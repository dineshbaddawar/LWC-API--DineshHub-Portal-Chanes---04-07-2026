public class SlackIntegrationHelper {
    private static final String SLACK_API_BASE_URL = 'https://slack.com/api';
    private static final String SLACK_OAUTH_ACCESS_TOKEN = System.Label.SLACK_OAUTH_ACCESS_TOKEN;
    
    public static String sendSlackMessage(String channelId, String message) {
        String endpoint = SLACK_API_BASE_URL + '/chat.postMessage';
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + SLACK_OAUTH_ACCESS_TOKEN);
        request.setBody('{"channel": "' + channelId + '", "text": "' + message + '"}');
        
        Http http = new Http();
        HttpResponse res = http.send(request);
        System.debug('');
        
        String returnValue = res.getBody();  
        System.debug('returnValue =====> ' + returnValue);
        
        return res.getBody();
    }
}