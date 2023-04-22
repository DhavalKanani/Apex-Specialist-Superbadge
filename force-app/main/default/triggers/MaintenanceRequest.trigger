trigger MaintenanceRequest on Case(before update, after update ){
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    Map<Id, Case> caseToUpdateList = new Map<Id, Case>();
    for (Case current : Trigger.new ){
        if (Trigger.oldMap.get(current.Id).IsClosed == false && +Trigger.newMap.get(current.Id).IsClosed)
            if (current.Type.equals('Repair') || current.Type.equals('Routine Maintenance')){
                caseToUpdateList.put(current.Id, current);
        }
    }
    MaintenanceRequestHelper.updateWorkOrders(caseToUpdateList);
}