public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders() {
       	List<case> caseList = new List<case>();     
		List<Equipment_Maintenance_Item__c> newEmiList = new List<Equipment_Maintenance_Item__c>();
        
        for(case c: [SELECT id,Vehicle__r.Name, ProductId, Vehicle__c,Subject, Product__c, (SELECT id,Equipment__c, Quantity__c, Equipment__r.Maintenance_Cycle__c from Equipment_Maintenance_Items__r) from case where status='closed' and Type IN ('Repair', 'Routine Maintenance') and ID IN :Trigger.new LIMIT 300]){
            case newCase = new Case();
            newCase.Type = 'Routine Maintenance';
            newCase.Status = 'New';
            newCase.Vehicle__c = c.Vehicle__c;
            newCase.Subject =  'Routine Maintenance Request-' + c.Vehicle__r.Name;
            newCase.Date_Reported__c = Date.today();
            newCase.ProductId = c.ProductId;
            newCase.Product__c = c.Product__c;
            newCase.parentID = c.Id;
            
            Decimal minCycle = 0;
            for(Equipment_Maintenance_Item__c emi : c.Equipment_Maintenance_Items__r ){
                minCycle = emi.Equipment__r.Maintenance_Cycle__c < minCycle || minCycle == 0? emi.Equipment__r.Maintenance_Cycle__c : minCycle;
                newEmiList.add(new Equipment_Maintenance_Item__c(                    
                    Equipment__c = emi.Equipment__c,
                    Maintenance_Request__c = c.id,
                    Quantity__c = emi.Quantity__c
                    )
            	);
            }
            Date dueDate = date.TODAY().adddays(Integer.valueOf(minCycle));
            newCase.Date_Due__c =dueDate;
            caseList.add(newCase);
            
        }
        if(caseList.size()>0){
            Database.insert(caseList);    
        }
        
        if(newEmiList.size()>0){
            
            for(Case c2: caseList){
                for(Equipment_Maintenance_Item__c e : newEmiList){
                    if(c2.parentID == e.Maintenance_Request__c){
                        e.Maintenance_Request__c = c2.id;    
                    }
                }                
            } 
            
            Database.insert(newEmiList);        
    	}        
    } 
}