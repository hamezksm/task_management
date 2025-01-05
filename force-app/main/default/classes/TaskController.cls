public with sharing class TaskController {
    @AuraEnabled(cacheable=true)
    public static List<Task__c> getTasks() {
        // Check if user has read access to Task__c object
        if (!Schema.sObjectType.Task__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to read Task records');
        }
        
        return [
            SELECT Id, Name, Due_Date__c, Completed__c 
            FROM Task__c 
            ORDER BY Due_Date__c ASC
            LIMIT 1000
        ];
    }
    
    @AuraEnabled
    public static void updateTaskCompletion(Id taskId) {
        // Check if user has update access to Task__c object
        if (!Schema.sObjectType.Task__c.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to update Task records');
        }
        
        // Check if user has update access to Completed__c field
        if (!Schema.sObjectType.Task__c.fields.Completed__c.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to update Task completion status');
        }
        
        Task__c task = new Task__c(Id = taskId, Completed__c = true);
        update task;
    }
}