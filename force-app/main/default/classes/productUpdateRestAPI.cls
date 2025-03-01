// It is used to update product value based on Productcode given in the JSON Body
@RestResource(urlMapping='/productupdateapi/*')
global class productUpdateRestAPI {
    
    @HttpPost
    global static responseWrapper updateProductdataUsingRequestBodyData(){
        try{
            responseWrapper responseJSON = new responseWrapper();
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String resBody = req.requestBody.toString();
            System.debug('resBody  ::'+resBody);
            String resp = responseHandler(resBody);
            responseJSON.Message = 'Update SUCCESS';
            return responseJSON;
        }catch(Exception e){
           HandleException.CreateErrorMsg('productUpdateRestAPI', 'productUpdateRestAPI', e);
        }
        return null;
    }
    
    global class responseWrapper{
        global String Message;
    }
    
    // Method for to handle the resquest body data
    public static String responseHandler(String resBody){
        System.debug('Inside onother method :'+resBody);
        LIst<RestProductWrapperUpdate> reqWrap = (List<RestProductWrapperUpdate>)JSON.deserialize(resBody, List<RestProductWrapperUpdate>.class);
        System.debug('Response Wrap :: '+reqWrap);
        Map<String,RestProductWrapperUpdate> resProductMap = new Map<String,RestProductWrapperUpdate>();
        for(RestProductWrapperUpdate prod : reqWrap){
            resProductMap.put(prod.PROCODE,prod);
        }
        System.debug('resProductMap :'+resProductMap);
        Map<id,Product2> reqProduct = new Map<Id,Product2>([SELECT ProductCode,Product_UOM__c,Product_UniqueCode__c FROM Product2 WHERE ProductCode IN: resProductMap.keySet()]);
        System.debug('reqProduct Result ::'+reqProduct);
        for(Product2 prod: reqProduct.values()){
            prod.Product_UniqueCode__c = resProductMap.get(prod.ProductCode).PROSKU;
            prod.Product_UOM__c = resProductMap.get(prod.ProductCode).UOM;
        }
        update reqProduct.valueS();
            System.debug('update Produt Records ::'+reqProduct.valueS());
        return 'Update SUCCESS 1 : '+'Product Id :'+reqProduct.keyset();
    }

    public class ResonseWrapperMethod{
        public List<RestProductWrapperUpdate> STOCK;
    }
    class RestProductWrapperUpdate{
        public String PROCODE;
        public String PROSKU;
        public String UOM;
    }
    
}

/* JSON Body
 [
    {

    "PROCODE" : "IN7040",

    "PROSKU": "1999",

    "UOM": "KG"

},

 {

    "PROCODE" : "GC1020",

    "PROSKU": "1999",

    "UOM": "kG"

}

]

*/