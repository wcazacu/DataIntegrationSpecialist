@IsTest
private class WarehouseCalloutServiceTest {
    
    @isTest static void mainTest(){    
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        Id jobID = System.enqueueJob(new WarehouseCalloutService());        
        Test.stopTest();
        AsyncApexJob jobStatus = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID];
        System.assertEquals(jobStatus.status,'Completed');
        System.assertEquals(0, jobStatus.NumberOfErrors);
    }
}