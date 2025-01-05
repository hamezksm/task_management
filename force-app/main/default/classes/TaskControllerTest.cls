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
    static void testGetTasksSuccess() {
        Test.startTest();
        List<Task__c> tasks = TaskController.getTasks();
        Test.stopTest();

        Assert.areEqual(1, tasks.size(), 'Should return one task');
        Assert.areEqual('Test Task', tasks[0].Name, 'Task name should match');
        Assert.areEqual(Date.today(), tasks[0].Due_Date__c, 'Due date should match');
        Assert.isFalse(tasks[0].Completed__c, 'Task should be incomplete');
    }

    @IsTest
    static void testUpdateTaskCompletionSuccess() {
        Task__c task = [SELECT Id, Completed__c FROM Task__c LIMIT 1];
        Assert.isFalse(task.Completed__c, 'Task should start incomplete');

        Test.startTest();
        TaskController.updateTaskCompletion(task.Id);
        Test.stopTest();

        task = [SELECT Id, Completed__c FROM Task__c WHERE Id = :task.Id];
        Assert.isTrue(task.Completed__c, 'Task should be marked complete');
    }

    @IsTest
    static void testUpdateTaskCompletionInvalidId() {
        Test.startTest();
        try {
            TaskController.updateTaskCompletion(null);
            Assert.fail('Should throw exception for null Id');
        } catch (AuraHandledException e) {
            // Expected exception
            Assert.areEqual('Invalid task Id', e.getMessage(), 'Exception message should match');
        }
        Test.stopTest();
    }
}