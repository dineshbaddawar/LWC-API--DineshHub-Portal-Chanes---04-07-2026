public class InvoicePaidPDFController {
    
    public Static Invoice__c invRec {get;set;}
    public Static String currentTime {get;set;}
    public Static Opportunity oppRec {get;set;}
    public String SubStartDate {get;set;}
    public String SubEndDate {get;set;}
   
    public  String  headerdata{get;set;}
    public string urlvalue{get;set;}
    public string url{get;set;}
    
    public InvoicePaidPDFController(ApexPages.StandardController controller){
        string invoiceid= ApexPages.currentPage().getParameters().get('id');

       // String url = 'https://utilitarianlabs-apiorg-dev-ed--c.vf.force.com/apex/InvoicePaidPDF?id=a085i00000FKqogAAD&docid=0065i00000BV6TqAAL';
        String url=Apexpages.currentPage().getUrl();
        List<String> urlParts = url.split('&');
        String docid = null;
        // Iterating through the URL parameters to find the 'docid' parameter
        for (String part : urlParts) {
            if (part.contains('docid=')) {
                // Splitting the parameter to get the 'docid' value
                List<String> paramParts = part.split('=');
                docid = paramParts[1];
                break;
            }
        }
        
        System.debug('docid: ' + docid);

        
        
        
   
        invRec = [SELECT Id,Name,Opportunity__c,Opportunity__r.AccountId,Subscription_End_Date__c,Subscription_Start_Date__c,Invoice_Date__c,Invoice_Amount__c,Delivery_Note__c,Shipping_Address__c,Billing_Address__c,Amount__c,Due_Amount_1__c,Mode_Terms_of_Payment__c FROM Invoice__c WHERE Id=:invoiceid];
        System.debug('invRec :::'+invRec);
        if(invRec.Subscription_Start_Date__c !=null){
            Date d = invRec.Subscription_Start_Date__c;
            Integer y = d.year();
            Integer m = d.month();
            Integer d1 = d.day();
            DateTime dt = DateTime.newInstance(y,m,d1);
            this.SubStartDate = dt.format('MMM dd, yyyy');
            Date endD = invRec.Subscription_End_Date__c;
            Integer endY = endD.year();
            Integer endM = endD.month();
            Integer endD1 = endD.day();
            DateTime endDT = DateTime.newInstance(endY,endM,endD1);
            this.SubEndDate = endDT.format('MMM dd, yyyy');
        }
        
        
        oppRec = [SELECT Id,Name,Amount,StageName,CloseDate FROM Opportunity WHERE ID =: invRec.Opportunity__c];
        System.debug('oppRec ::'+oppRec);
    }
    
    @AuraEnabled
    public static string savePDF(String recordId){
        try {
            
            Invoice__c inv = [SELECT Id,Name FROM Invoice__c WHERE Id=:recordId LIMIT 1];
            
            String str = String.valueOf(System.now());
            String[] str2 = str.split(' ');
            String str1format = str2[0].replace('-','_');
            String str1format1 = str2[1].replace(':','_');
            String FileName = str1format +'_'+ str1format1;
            
            
            List<Attachment> attachmentList = new List<Attachment>();
            PageReference pageRef = page.InvoicePaidPDF;
            pageRef.getParameters().put('id',recordId);
            blob vBody;
            vBody=pageRef.getContent();
            Attachment attach = new Attachment();
            attach.Body = vBody;
            
            attach.Name = inv.Name+'_'+FileName+'.pdf';
            attach.ParentId = recordId;
            attach.ContentType = 'application/pdf';
            attachmentList.add(attach);
            if(!attachmentList.isEmpty()){
                insert attachmentList;
                system.debug('attachmentList ID==>' +attachmentList[0].Id);
            }
            return attachmentList[0].Id;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}