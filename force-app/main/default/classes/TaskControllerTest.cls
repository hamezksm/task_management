@IsTest
private class TaskControllerTest {
    @TestSetup
    static void setupTestData() {
        Task__c task = new Task__c(
            Name = 'Test Task',
            Due_Date__c = Date.today(),
            Completed__c = false
        );
        insert task;
    }
    
    @IsTest
    static void testGetTasks() {
        Test.startTest();
        List<Task__c> tasks = TaskController.getTasks();
        Test.stopTest();
        
        Assert.areEqual(1, tasks.size(), 'Should return one task');
        Assert.areEqual('Test Task', tasks[0].Name, 'Task name should match');
    }
    
    @IsTest
    static void testUpdateTaskCompletion() {
        Task__c task = [SELECT Id, Completed__c FROM Task__c LIMIT 1];
        Assert.isFalse(task.Completed__c, 'Task should start as incomplete');
        
        Test.startTest();
        TaskController.updateTaskCompletion(task.Id);
        Test.stopTest();
        
        task = [SELECT Id, Completed__c FROM Task__c WHERE Id = :task.Id];
        Assert.isTrue(task.Completed__c, 'Task should be marked as complete');
    }
    
    @IsTest
    static void testUpdateTaskCompletionWithInvalidId() {
        Test.startTest();
        try {
            TaskController.updateTaskCompletion(null);
            Assert.fail('Should throw exception for null Id');
        } catch (AuraHandledException e) {
            Assert.areEqual('Task ID is required', e.getMessage(), 'Should throw correct error message');
        }
    }
}