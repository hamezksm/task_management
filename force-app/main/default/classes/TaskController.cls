public with sharing class TaskController {
    @AuraEnabled(cacheable=true)
    public static List<Task__c> getTasks() {
        if (!Schema.sObjectType.Task__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to read Task records');
        }
        return [SELECT Id, Name, Due_Date__c, Completed__c 
                FROM Task__c 
                ORDER BY Due_Date__c ASC
                LIMIT 1000];
    }
    
    @AuraEnabled
    public static void updateTaskCompletion(Id taskId) {
        if (taskId == null) {
            throw new AuraHandledException('Invalid task ID');
        }
        
        if (!Schema.sObjectType.Task__c.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to update Task records');
        }
        
        if (!Schema.sObjectType.Task__c.fields.Completed__c.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to update Task completion status');
        }
        
        List<Task__c> tasks = [SELECT Id FROM Task__c WHERE Id = :taskId];
        if (tasks.isEmpty()) {
            throw new AuraHandledException('Task not found');
        }
        
        try {
            Task__c taskToUpdate = new Task__c(Id = taskId, Completed__c = true);
            update taskToUpdate;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to update task: ' + e.getMessage());
        }
    }
}