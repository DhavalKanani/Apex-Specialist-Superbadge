public with sharing class MaintenanceRequestHelper{
    static final Integer MAX_VALUE = 100000;
    public static void updateWorkOrders(Map<Id, Case> oldCase){
        // TODO: Complete the method to update workorders
        /*
         STEP 1: create new case based on old case and insert it to database
         STEP 2: create Equipment_Maintenance_Item related to old case for new case and also put value of minimum equipment life cycle
         STEP 3: update due date field from newly created case
         */

        if (oldCase.values().size() <= 0)
            return;
        Map<Id, Case> newCasesbyOldCase = new Map<Id, Case>();
        Map<Id, Integer> dueDateForNewCase = new Map<Id, Integer>();

        // STEP 1
        //create new cases based on old cases
        for (Case current : oldCase.values()){
            newCasesbyOldCase.put(current.Id, new Case(Vehicle__c = current.Vehicle__c, Type = 'Routine Maintenance', Date_Reported__c = Date.today(), Subject = 'future routine checkup for ' + current.Id));
            dueDateForNewCase.put(current.Id, MAX_VALUE);
        }

        insert newCasesbyOldCase.values();

        // STEP 2
        //fetch related Equipment_Maintenance_Item__c for old cases
        List<Equipment_Maintenance_Item__c> relatedEquipments = [SELECT Id, Maintenance_Request__c, Equipment__c, Equipment__r.Maintenance_Cycle__c
                                                                 FROM Equipment_Maintenance_Item__c
                                                                 WHERE Maintenance_Request__c IN:oldCase.keySet()];
        List<Equipment_Maintenance_Item__c> newMaintenanceItemByOldCase = new List<Equipment_Maintenance_Item__c>();


        for (Equipment_Maintenance_Item__c current : relatedEquipments){
            newMaintenanceItemByOldCase.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = newCasesbyOldCase.get(current.Maintenance_Request__c).Id, Equipment__c = current.Equipment__c));

            if (current.Equipment__r.Maintenance_Cycle__c < dueDateForNewCase.get(current.Maintenance_Request__c))
                dueDateForNewCase.put(current.Maintenance_Request__c, (Integer) current.Equipment__r.Maintenance_Cycle__c);
        }

        insert newMaintenanceItemByOldCase;


        // STEP 3
        for (Case current : oldCase.values()){
            Date dueDate = Date.today();
            if (dueDateForNewCase.get(current.Id) != MAX_VALUE){
                dueDate += dueDateForNewCase.get(current.Id);
            }
            newCasesbyOldCase.get(current.id).Date_Due__c = dueDate;

        }
        update newCasesbyOldCase.values();
        //system.debug(lstContact);
    }

}