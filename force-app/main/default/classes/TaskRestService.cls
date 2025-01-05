@RestResource(urlMapping='/tasks/*')
global with sharing class TaskRestService {
    @HttpGet
    global static List<Task__c> getTasks() {
        if (Schema.sObjectType.Task__c.isAccessible()) {
            return [SELECT Id, Name, Due_Date__c, Completed__c FROM Task__c];
        } else {
            // Handle the lack of access appropriately
            RestContext.response.statusCode = 403;
            RestContext.response.responseBody = Blob.valueOf('Access to Task__c is denied.');
            return new List<Task__c>();
        }
    }
}