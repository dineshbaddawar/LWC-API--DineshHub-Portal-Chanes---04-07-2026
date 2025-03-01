public class BatchRenderAsPDF implements Database.Batchable <Sobject> {
    
    public Database.QueryLocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id,Name FROM Account WHERE  ID = \'0015i00000RGKcYAAX\' ';
        return Database.getQueryLocator(query);
    }
    
    public void Execute(Database.BatchableContext bc, List<Account> accList){
        System.debug('accList :'+accList);
        List<Attachment> AttToInsert = new List<Attachment>();
        for(Account acc : accList){
            PageReference pdfpage = Page.RenderAsPDF;
            pdfpage.getParameters().put('id',acc.id);
            
            ContentVersion contv = new ContentVersion();
            contv.Title = acc.Name +' .pdf';
            contv.PathOnClient = 'File.pdf';
            contv.VersionData = pdfpage.getContentAsPDF();
            contv.Origin = 'H';
            insert contv;
            System.debug('contv ::'+contv);
        }
    }
    
    public void Finish(Database.BatchableContext bc){
        System.debug('Batch Run Successfully');
    }
    
    public static ContentDocumentLink createContentDocumentLink(String contvId, String recordId){
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE ID =:contvId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try{
            insert cdl;
            System.debug('Successs :'+cdl);
            return cdl;
        }catch(Exception e){
            System.debug('The Error :'+e.getMessage()+' The Error Line :'+e.getLineNumber());
            return null;
        }
       // return null;
    }
}