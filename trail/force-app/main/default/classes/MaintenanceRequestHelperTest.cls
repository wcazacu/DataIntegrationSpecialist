@isTest
public with sharing class MaintenanceRequestHelperTest {
    
    @testSetup static void setup(){

        CreateDefaultData.createDefaultData();

    }

    @isTest 
    static void Test_ControllingObjectTestPageController(){
        
        case existingCase = [select id, status,(SELECT id,Equipment__c, Quantity__c, Equipment__r.Maintenance_Cycle__c from Equipment_Maintenance_Items__r) from case where status='New' and Type IN ('Repair', 'Routine Maintenance') limit 1];
        existingCase.Status = 'Closed';
        update existingCase;
        
        Case newCase= [select id, subject,(SELECT id,Equipment__c, Quantity__c, Equipment__r.Maintenance_Cycle__c from Equipment_Maintenance_Items__r) from case where parentID = :existingCase.Id];
        System.assertNotEquals('', newcase.subject);
        
        System.assertEquals(existingCase.Equipment_Maintenance_Items__r.size(), newcase.Equipment_Maintenance_Items__r.size());
    }
}