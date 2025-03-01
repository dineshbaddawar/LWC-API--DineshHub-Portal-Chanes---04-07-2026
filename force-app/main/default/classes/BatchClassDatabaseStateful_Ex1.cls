global class BatchClassDatabaseStateful_Ex1 implements Database.Batchable<sObject>, Database.Stateful {
    global Integer recordsProcessed = 0; // variable to keep track of the count
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Name,Description FROM Account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        for(Account acc : scope){
            acc.Description = 'Updated Description';
        }
        // implementation of execute method
        recordsProcessed += scope.size(); // increment the count by the number of records processed in this batch
        System.debug('Inside Execute == >'+recordsProcessed);
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Current Size == >'+recordsProcessed);
        // implementation of finish method
        if(recordsProcessed < 20  ){
            BatchClassDatabaseStateful_Ex1 anotherBatch = new BatchClassDatabaseStateful_Ex1();
            Database.executeBatch(anotherBatch);
        }
        System.debug('Records processed Finish: ' + recordsProcessed);  
    }
}