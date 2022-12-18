@isTest
public with sharing class WarehouseSyncScheduleTest {
    public static string CRON_EXP = '0 0 1 * * ?';
  
    @isTest    
    public static void scTest(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        String jobId = System.schedule('WarehouseSyncScheduleJob1', CRON_EXP, new WarehouseSyncSchedule());
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        
        System.assertEquals(0, cronTrigger.TimesTriggered);
        System.assertEquals(DateTime.Now().Date()+1, cronTrigger.NextFireTime.Date());
        Test.stopTest();
        
    }
}