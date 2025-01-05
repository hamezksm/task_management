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
        Assert.isFalse(tasks[0].Completed__c, 'Task should be incomplete');
    }
    
    @IsTest
    static void testUpdateTaskCompletion() {
        Task__c task = [SELECT Id, Completed__c FROM Task__c LIMIT 1];
        Assert.isFalse(task.Completed__c, 'Task should start as incomplete');
        
        Test.startTest();
        TaskController.updateTaskCompletion(task.Id);
        Test.stopTest();
        
        Task__c updatedTask = [SELECT Id, Completed__c FROM Task__c WHERE Id = :task.Id];
        Assert.isTrue(updatedTask.Completed__c, 'Task should be marked as complete');
    }
    
    @IsTest
    static void testGetTasksWithoutAccess() {
        Test.startTest();
        try {
            // Mock no access
            PermissionSets.assign(UserInfo.getUserId(), 'No_Task_Access');
            TaskController.getTasks();
            Assert.fail('Should throw exception when user lacks read access');
        } catch (AuraHandledException e) {
            Assert.areEqual('Insufficient permissions to read Task records', 
                           e.getMessage(), 
                           'Should throw correct error message');
        }
        Test.stopTest();
    }
    
    @IsTest
    static void testUpdateTaskCompletionWithoutAccess() {
        Task__c task = [SELECT Id FROM Task__c LIMIT 1];
        
        Test.startTest();
        try {
            // Mock no access
            PermissionSets.assign(UserInfo.getUserId(), 'No_Task_Access');
            TaskController.updateTaskCompletion(task.Id);
            Assert.fail('Should throw exception when user lacks update access');
        } catch (AuraHandledException e) {
            Assert.areEqual('Insufficient permissions to update Task records', 
                           e.getMessage(), 
                           'Should throw correct error message');
        }
        Test.stopTest();
    }
}