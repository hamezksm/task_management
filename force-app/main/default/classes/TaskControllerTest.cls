@IsTest
private class TaskControllerTest {
    @TestSetup
    static void makeData() {
        // Create test tasks
        List<Task__c> tasks = new List<Task__c>();
        for(Integer i = 0; i < 3; i++) {
            tasks.add(new Task__c(
                Name = 'Test Task ' + i,
                Due_Date__c = Date.today().addDays(i),
                Completed__c = false
            ));
        }
        insert tasks;
    }
    
    @IsTest
    static void testGetTasksSuccess() {
        // Act
        Test.startTest();
        List<Task__c> tasks = TaskController.getTasks();
        Test.stopTest();
        
        // Assert
        System.assertEquals(3, tasks.size(), 'Should return all test tasks');
        System.assertEquals('Test Task 0', tasks[0].Name, 'First task should match');
        System.assertEquals(Date.today(), tasks[0].Due_Date__c, 'Due date should match');
        System.assertEquals(false, tasks[0].Completed__c, 'Completion status should match');
        
        // Verify order
        for(Integer i = 1; i < tasks.size(); i++) {
            System.assert(tasks[i].Due_Date__c >= tasks[i-1].Due_Date__c, 
                'Tasks should be ordered by due date');
        }
    }
    
    @IsTest
    static void testUpdateTaskCompletionSuccess() {
        // Arrange
        Task__c task = [SELECT Id, Completed__c FROM Task__c WHERE Name = 'Test Task 0' LIMIT 1];
        
        // Act
        Test.startTest();
        TaskController.updateTaskCompletion(task.Id);
        Test.stopTest();
        
        // Assert
        Task__c updatedTask = [SELECT Completed__c FROM Task__c WHERE Id = :task.Id];
        System.assertEquals(true, updatedTask.Completed__c, 'Task should be marked as completed');
    }
    
    @IsTest
    static void testGetTasksNoAccess() {
        // Arrange
        // Create a user without access to Task__c
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test.user' + DateTime.now().getTime() + '@example.com',
            Username = 'test.user' + DateTime.now().getTime() + '@example.com',
            EmailEncodingKey = 'UTF-8',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        
        // Act & Assert
        System.runAs(u) {
            Test.startTest();
            try {
                TaskController.getTasks();
                System.assert(false, 'Should have thrown an exception');
            } catch(AuraHandledException e) {
                System.assert(e.getMessage().contains('Insufficient permissions'), 
                    'Should throw permission error');
            }
            Test.stopTest();
        }
    }
    
    @IsTest
    static void testUpdateTaskCompletionNoAccess() {
        // Arrange
        Task__c task = [SELECT Id FROM Task__c WHERE Name = 'Test Task 0' LIMIT 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test.user' + DateTime.now().getTime() + '@example.com',
            Username = 'test.user' + DateTime.now().getTime() + '@example.com',
            EmailEncodingKey = 'UTF-8',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        
        // Act & Assert
        System.runAs(u) {
            Test.startTest();
            try {
                TaskController.updateTaskCompletion(task.Id);
                System.assert(false, 'Should have thrown an exception');
            } catch(AuraHandledException e) {
                System.assert(e.getMessage().contains('Insufficient permissions'), 
                    'Should throw permission error');
            }
            Test.stopTest();
        }
    }
    
    @IsTest
    static void testUpdateTaskCompletionInvalidId() {
        // Act & Assert
        Test.startTest();
        try {
            TaskController.updateTaskCompletion(null);
            System.assert(false, 'Should have thrown an exception');
        } catch(AuraHandledException e) {
            System.assert(e.getMessage().contains('FIELD_INTEGRITY_EXCEPTION'), 
                'Should throw field integrity error');
        }
        Test.stopTest();
    }
}