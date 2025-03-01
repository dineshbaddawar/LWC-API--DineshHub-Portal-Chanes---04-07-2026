public without sharing class GeolocationController {
    
    
    public Static Map<String,String> getLongandLat(String Addresss){
        Map<String,String> responseMap = new Map<String,String>();
        String apikey = 'AIzaSyAa_4WvRuK0FC1FgIbdM-4LjO9T2BG2Q20'; // Updated API Key - 19/07/2024
        String baseURL = 'https://maps.googleapis.com/maps/api/geocode/json?address=';
        
        String encodedAddresss = EncodingUtil.urlEncode(Addresss, 'UTF-8');
        String url = baseURL+encodedAddresss+'&key='+apikey;
        System.debug('encoded url ::'+url);
        Http ht =new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Length', '0');
        HttpResponse res = ht.send(req);
        String response = (res.getBody());
        System.debug('response ::'+response);
        
        // New Method Start
        System.JSONParser parser = JSON.createParser(response);
        System.debug('parser == > ::'+parser);
        Double latitude;
        Double longitude;
        Boolean foundLocation = false;
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = parser.getText();
                if (fieldName == 'location') {
                    parser.nextToken(); // Move to the start object token
                    parser.nextToken(); // Move to the lat field
                    // Check if the next field is "lat"
                    if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'lat') {
                        parser.nextToken(); // Move to the value
                        latitude = parser.getDoubleValue();
                    }
                    parser.nextToken(); // Move to the lng field
                    // Check if the next field is "lng"
                    if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'lng') {
                        parser.nextToken(); // Move to the value
                        longitude = parser.getDoubleValue();
                    }
                    foundLocation = true;
                    break; //
                }
            }
        }
        if (foundLocation) {
            // Output latitude and longitude
            System.debug('Latitude: ' + latitude);
            System.debug('Longitude: ' + longitude);
            
            // You can use the latitude and longitude as needed in your Salesforce logic
        } else {
            System.debug('Location not found in JSON response');
        }
        // New Method End
        
        //locationparser parsedJson = JSON.deserialize(res.getBody(), LocationParser.Class);
        //system.debug('parsedJson ====> ' + parsedJson);
        
        LocationParser parsedJson = LocationParser.parse(res.getBody());
        system.debug('parsedJson ====> ' + parsedJson);
        system.debug('parsedJson results ====> ' + parsedJson.results);
        
        LocationParser.Results parserResult = parsedJson.results[0];
        LocationParser.Geometry parserGeometry = parserResult.geometry;
        LocationParser.Location parserLocation = parserGeometry.location;
        Double lat = parserLocation.lat;
        Double lang = parserLocation.lng;
        
        responseMap.put('lat',String.valueOf(lat));
        responseMap.put('lang',String.valueOf(lang));
        
        System.debug('responseMap---'+String.valueOf(responseMap));
        
        return responseMap;
    }
}