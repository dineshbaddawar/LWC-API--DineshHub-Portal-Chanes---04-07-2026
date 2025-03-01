public class PaypalApiHelper {
    
    // Set your PayPal credentials
    private static String paypalClientId = 'AV5X44f8LVTF52rguFH7g0urYbOL730a1h3Au51h2_0ILlJy6xXQ7NWo3WD-defJrP-2yBs9vsb1W4IC';
    private static String paypalClientSecret = 'EIcJ2Bvg2JrclmSyJZv1U7c-y1obX0sn1AHb6q9EMRo7mAj_UR4nlgOVIv_w_G_jPSvpQNs1_anGKz7f';
    private static String paypalApiEndpoint = 'https://api.sandbox.paypal.com'; // Use the sandbox endpoint for testing
    
    // Get Access Token from PayPal
    public static String getAccessToken() {
        String endpoint = paypalApiEndpoint + '/v1/oauth2/token';
        String body = 'grant_type=client_credentials';
        String authHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(paypalClientId + ':' + paypalClientSecret));
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', authHeader);
        request.setBody(body);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        
        String AccessToken = (String) jsonResponse.get('access_token');
        System.debug('Access Token === >'+AccessToken);
        return AccessToken;
    }
    
    Public static void createPayment(){
        String PaymentLink;
        String jsonString = '{ "intent": "sale", "payer": { "payment_method": "paypal" }, "transactions": [ { "amount": { "total": "4.11", "currency": "USD", "details": { "subtotal": "4.00", "tax": "0.07", "shipping": "0.03", "handling_fee": "1.00", "shipping_discount": "-1.00", "insurance": "0.01" } }, "description": "The payment transaction description.", "custom": "EBAY_EMS_90048630024435", "invoice_number": "48787589673", "payment_options": { "allowed_payment_method": "INSTANT_FUNDING_SOURCE" }, "soft_descriptor": "ECHI5786786", "item_list": { "items": [ { "name": "hat", "description": "Brown hat.", "quantity": "1", "price": "2", "tax": "0.01", "sku": "1", "currency": "USD" }, { "name": "handbag", "description": "Black handbag.", "quantity": "1", "price": "2", "tax": "0.02", "sku": "product34", "currency": "USD" } ], "shipping_address": { "recipient_name": "Brian Robinson", "line1": "4th Floor", "line2": "Unit #34", "city": "San Jose", "country_code": "US", "postal_code": "95131", "phone": "011862212345678", "state": "CA" } } } ], "note_to_payer": "Contact us for any questions on your order.", "redirect_urls": { "return_url": "https://example.com/return", "cancel_url": "https://example.com/cancel" } }';
        String endpoint ='https://api-m.sandbox.paypal.com/v1/payments/payment';
        String accessToken = getAccessToken();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(jsonString);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('response getBody === >'+response.getBody());
        
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        System.debug('jsonResponse === >'+jsonResponse);
        List<Object> linksList = (List<Object>)jsonResponse.get('links');
        System.debug('linksList === >'+linksList);
        for(Object link : linksList){
            Map<String, Object> linkMap = (Map<String, Object>)link;
            String href = (String)linkMap.get('href');
            String method = (String)linkMap.get('method');
            String rel = (String)linkMap.get('rel');
            if(method == 'REDIRECT'){
                PaymentLink = href;
            }
            System.debug('Link === >'+href +' , Method === >'+method+' , Rel === >'+rel);
            System.debug('Payment Link === >'+PaymentLink);
        }
        
    }
    
}