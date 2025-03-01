public class CurrencyConvertAPI {
    
    public Static Opportunity oppAmountINRtoUSD(List<Opportunity> oppList){
        try{
            Set<Id> OppIdSet = new Set<Id>();
            for(Opportunity opp : oppList){
                OppIdSet.add(opp.id);
            }
            Opportunity opp = [SELECT Id,StageName,Amount,Closedate,Name,Amount_in_USD__c FROM Opportunity Where Id IN :OppIdSet LIMIT 1];
             System.debug('opp ::'+opp);
            if(opp.Amount !=null){
               CurrencyConvertAPI.currecncyConvertAPI(opp.Amount,opp.Id); 
            }
            return opp;
        }catch(Exception e){
             HandleException.CreateErrorMsg('CurrencyConvertAPI', 'oppAmountINRtoUSD', e);
        }
        return null;
    }
    
      @future (callout=true)
    public Static void currecncyConvertAPI(Decimal oppAmount,String oppId){
        try{
            // URL : https://anyapi.io/api/v1/exchange/convert?apiKey=8p7oiilpsvgkask6otlnmg49eu73ammvgs7obpgh8n2gngmgdvo0e2o&base=USD&to=INR&amount=1
            String BaseURL  = Label.ExchangeAPIURL;
            String ApIkey = Label.ExchangeAPIKey;
            String endpoint = BaseURL+ApIkey+'&base=INR&to=USD&amount='+oppAmount;
            System.debug('endpoint ::'+endpoint);
            Http http = new Http();
            HttpRequest request = new HttpRequest(); 
            request.setMethod('GET');
            request.setEndpoint(endpoint); 
            HttpResponse response ;
            response = http.send(request);
            if(response.getStatusCode() == 200 && response.getBody() !=null){
                system.debug('response.getStatusCode()   ::'+response.getStatusCode());
                System.debug('Response  Body ::'+ response.getBody());
                String jsonResponse = response.getBody();
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('results ::'+results);
                Decimal logsList = (Decimal)results.get('converted');
                System.debug('converted ::'+logsList);
                Opportunity opp = new Opportunity();
                opp.Id = oppId;
                opp.Amount_in_USD__c = logsList;
                update opp;
                system.debug('opp update Record ::'+opp);
            }
        }catch(Exception e){
            HandleException.CreateErrorMsg('CurrencyConvertAPI', 'currecncyConvertAPI', e);
        }
        
    }
}