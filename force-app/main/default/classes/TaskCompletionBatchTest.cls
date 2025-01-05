@IsTest
private class TaskCompletionBatchTest {
    @TestSetup
    static void makeData(){
        List<Task__c> tasks = new List<Task__c>();
        for(Integer i = 0; i < 10; i++) {
            tasks.add(new Task__c(
                Name = 'Test Task ' + i,
                Due_Date__c = Date.today().addDays(-1),
                Completed__c = false
            ));
        }
        insert tasks;
    }
    
    @IsTest
    static void testBatch() {
        Test.startTest();
        TaskCompletionBatch batch = new TaskCompletionBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        List<Task__c> updatedTasks = [SELECT Id, Completed__c FROM Task__c];
        for(Task__c task : updatedTasks) {
            System.assertEquals(true, task.Completed__c, 'Task should be marked as completed');
        }
    }
}