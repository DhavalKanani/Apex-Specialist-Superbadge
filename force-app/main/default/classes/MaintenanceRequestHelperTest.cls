@isTest
public with sharing class MaintenanceRequestHelperTest{
    // implement scheduled code here
    static Product2 createEquipment(String name){
        return new Product2(Name = name, Replacement_Part__c = true, Cost__c = 100, Current_Inventory__c = 100, Lifespan_Months__c = 10, Maintenance_Cycle__c = 15);
    }

    static Case createMaintananceRequest(Id vehicleId, String type, String subject){
        return new Case(Vehicle__c = vehicleId, Type = type, Date_Reported__c = Date.today(), Subject = subject);
    }

    static Vehicle__c createVehicle(String name){
        return new Vehicle__c(name = name);
    }

    static Equipment_Maintenance_Item__c createEMI(Id maintainanceRequestId, Id equipmentId){
        return new Equipment_Maintenance_Item__c(Maintenance_Request__c = maintainanceRequestId, Equipment__c = equipmentId);
    }

    @isTest
    static void positiveTestCase(){


        Product2 e1 = createEquipment('TestEquipment1');
        Product2 e2 = createEquipment('TestEquipment2');
        Vehicle__c v1 = createVehicle('TestVehicle1');

        insert e1;
        insert e2;
        insert v1;

        Case mr1 = createMaintananceRequest(v1.Id, 'Routine Maintenance', 'mr1');
        insert mr1;

        Equipment_Maintenance_Item__c emi1 = createEMI(mr1.Id, e1.Id);
        Equipment_Maintenance_Item__c emi2 = createEMI(mr1.Id, e2.Id);
        insert emi1;
        insert emi2;

        mr1.Status = 'Closed';
        update mr1;

        List<Case> totalCase = [SELECT Id
                                FROM Case];
        List<Equipment_Maintenance_Item__c> totalEMI = [SELECT Id
                                                        FROM Equipment_Maintenance_Item__c];
        system.assertEquals(totalCase.size(), 2);
        system.assertEquals(totalEMI.size(), 4);
    }

    @isTest
    static void nagativeTestCase(){


        Product2 e1 = createEquipment('TestEquipment1');
        Product2 e2 = createEquipment('TestEquipment2');
        Vehicle__c v1 = createVehicle('TestVehicle1');

        insert e1;
        insert e2;
        insert v1;

        Case mr1 = createMaintananceRequest(v1.Id, 'Other', 'mr1');
        insert mr1;

        Equipment_Maintenance_Item__c emi1 = createEMI(mr1.Id, e1.Id);
        Equipment_Maintenance_Item__c emi2 = createEMI(mr1.Id, e2.Id);
        insert emi1;
        insert emi2;

        mr1.Status = 'Closed';
        update mr1;

        List<Case> totalCase = [SELECT Id
                                FROM Case];
        List<Equipment_Maintenance_Item__c> totalEMI = [SELECT Id
                                                        FROM Equipment_Maintenance_Item__c];
        system.assertEquals(totalCase.size(), 1);
        system.assertEquals(totalEMI.size(), 2);
    }

    @isTest
    static void bulkTestCase(){


        Product2 e1 = createEquipment('TestEquipment1');
        Vehicle__c v1 = createVehicle('TestVehicle1');

        insert e1;
        insert v1;

        List<Case> MRToInsert = new List<Case>();

        for (Integer i = 1; i <= 300; i++){
            MRToInsert.add(createMaintananceRequest(v1.Id, 'Routine Maintenance', 'mrbulk' + i));
        }
        insert MRToInsert;

        List<Equipment_Maintenance_Item__c> emiToInsert = new List<Equipment_Maintenance_Item__c>();
        for (Case current : MRToInsert){
            emiToInsert.add(createEMI(current.Id, e1.Id));
        }
        insert emiToInsert;


        for (Case current : MRToInsert){
            current.Status = 'Closed';
        }

        update MRToInsert;

        List<Case> totalCase = [SELECT Id
                                FROM Case];
        List<Equipment_Maintenance_Item__c> totalEMI = [SELECT Id
                                                        FROM Equipment_Maintenance_Item__c];
        system.assertEquals(totalCase.size(), 600);
        system.assertEquals(totalEMI.size(), 600);
    }

}