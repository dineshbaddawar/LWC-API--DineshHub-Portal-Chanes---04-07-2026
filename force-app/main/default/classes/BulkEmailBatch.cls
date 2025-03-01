public class BulkEmailBatch implements Database.Batchable <Sobject> {
    
    public Database.QueryLocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id,Name,Email FROM Contact LIMIT 25 ';
        return Database.getQueryLocator(query);
    }
    
    public void Execute(Database.BatchableContext bc,List<Contact> conList){
        System.debug('contact Size ==> '+conList.size());
        EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Reset Password Link'];
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        List<String> ToaddressList = new List<String>();
        for(Contact con : conList){
                String hardId = 'a085i00000ByxYvAAJ';
                PageReference pdfPage = Page.InvoicePaidPDF;
                pdfPage.getParameters().put('id',hardId);
                System.debug('pdfPage ::'+pdfPage);
                Blob Blobbody;
                Blobbody =  (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('Fake content'));
                
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setContentType('application/pdf');
                attach.setFileName('Bulk Email test.pdf');
                attach.setInline(false);
                attach.Body = Blobbody;
                
                String htmlBody = temp.HTMLValue;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSubject('HIC Global Solutions');
                mail.setplaintextbody('Welcome to HIC Global Solutions');
                mail.setToAddresses(new List<String>{con.Email});
              //  mailList.add(mail);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
                mailList.add(mail);
           // }
            
        }
        
        
        
        if(!mailList.isEmpty()){
            Messaging.sendEmail(mailList);
        }
    }
    
    public void Finish(Database.BatchableContext bc){
        
    }
}