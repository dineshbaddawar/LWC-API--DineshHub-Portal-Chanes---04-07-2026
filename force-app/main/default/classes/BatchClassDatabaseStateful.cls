public class BatchClassDatabaseStateful implements Database.Batchable <Sobject> , Database.stateful {
    public integer contactRecordProcessed = 0;
    public Database.QueryLocator Start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id,Name,BillingCity,(SELECT Id,Name,MailingCity FROM Contacts) FROM Account');
    }
    public void Execute(Database.BatchableContext bc, List<Account> accList){
        List<Contact> conList = new List<Contact>();
         System.debug('Previous contactRecordProcessed 1 == > '+contactRecordProcessed);
        if(accList.size()>0){
            for(Account acc : accList){
                for(Contact con : acc.Contacts){
                    con.MailingCity = acc.BillingCity;
                    conList.add(con);
                    contactRecordProcessed = contactRecordProcessed +1;
                }
            }
            System.debug('contactRecordProcessed 2 == > '+contactRecordProcessed);
            update conList;
              System.debug('Updated conList == >'+conList.size());
        }
    }
    public void Finish(Database.BatchableContext bc){
        System.debug('Batch Run Successfully');
    }
}