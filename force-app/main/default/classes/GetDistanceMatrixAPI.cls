public class GetDistanceMatrixAPI {
    
    @AuraEnabled
    public static GoogleDistanceMatrixWrapper GetDistanceFromGoogleMaps(String Origin,String Destination){
        
        String auth_key = 'AIzaSyAPWOnnHpA4OEwle5ens5UEZDMfDnQ-nBM';
        String EndPoint = 'https://maps.googleapis.com/maps/api/distancematrix/json?';
        EndPoint += 'units=imperial'+'&origins='+Origin+'&destinations='+Destination+'&key='+auth_key;
        System.debug('Endpoint ::'+EndPoint);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(EndPoint);
        HttpResponse rep = http.send(req);
        System.debug('***Response**'+rep.getbody());
        GoogleDistanceMatrixWrapper GoogleDistanceMatrix = new GoogleDistanceMatrixWrapper();
        if(rep.getbody() != null ){
            GoogleDistanceMatrix  = GoogleDistanceMatrixWrapper.parse(rep.getbody());
             Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(rep.getBody());
            System.debug('results :::'+results);
             List<Object> animals = (List<Object>) results.get('destination_addresses');
            System.debug('animals ::'+animals);
            if(GoogleDistanceMatrix.status == 'OK'){
                System.debug('***GoogleDistanceMatrix**'+GoogleDistanceMatrix);
                return GoogleDistanceMatrix;
            }
        }
        return null;   
    }
    
}