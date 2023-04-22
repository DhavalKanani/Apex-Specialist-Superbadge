public with sharing class WarehouseSyncSchedule implements Schedulable{
    global void execute(SchedulableContext SC){
        String jobID = System.enqueueJob(new WarehouseCalloutService());
    }

}