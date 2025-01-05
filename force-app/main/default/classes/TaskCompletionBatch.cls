public class TaskCompletionBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Task__c WHERE Completed__c = false]);
    }
    
    public void execute(Database.BatchableContext bc, List<Task__c> scope) {
        for(Task__c task : scope) {
            task.Completed__c = true;
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext bc) {
        // Simplified finish method without invalid getQuerySize() call
        System.debug('Batch job completed successfully');
    }
}