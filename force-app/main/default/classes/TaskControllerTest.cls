@IsTest
private class TaskControllerTest {
    @TestSetup
    static void setupTestData() {
        // Create permission set
        PermissionSet ps = new PermissionSet(
            Label = 'Task Manager',
            Name = 'Task_Manager'
        );
        insert ps;

        // Add field permissions
        FieldPermissions fp = new FieldPermissions(
            ParentId = ps.Id,
            SobjectType = 'Task__c',
            Field = 'Task__c.Completed__c',
            PermissionsEdit = true,
            PermissionsRead = true
        );
        insert fp;

        // Add object permissions
        ObjectPermissions op = new ObjectPermissions(
            ParentId = ps.Id,
            SObjectType = 'Task__c',
            PermissionsRead = true,
            PermissionsCreate = true,
            PermissionsEdit = true
        );
        insert op;

        // Create and assign test user
        User testUser = createTestUser();
        insert testUser;

        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa;

        // Create test task
        System.runAs(testUser) {
            Task__c task = new Task__c(
                Name = 'Test Task',
                Due_Date__c = Date.today(),
                Completed__c = false
            );
            insert task;
        }
    }

    private static User createTestUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        return new User(
            ProfileId = p.Id,
            LastName = 'TestUser',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
    }

    @IsTest
    static void testUpdateTaskCompletion() {
        User testUser = [SELECT Id FROM User WHERE Username LIKE 'test@test.com%' LIMIT 1];
        Task__c task = [SELECT Id FROM Task__c LIMIT 1];
        
        System.runAs(testUser) {
            Test.startTest();
            TaskController.updateTaskCompletion(task.Id);
            Test.stopTest();

            Task__c updatedTask = [SELECT Id, Completed__c FROM Task__c WHERE Id = :task.Id];
            System.assert(updatedTask.Completed__c, 'Task should be marked as completed');
        }
    }

    @IsTest
    static void testGetTasks() {
        Test.startTest();
        List<Task__c> tasks = TaskController.getTasks();
        Test.stopTest();
        
        System.assertEquals(1, tasks.size(), 'Should return one task');
    }
}