public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts{
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    public void execute(QueueableContext context){

        List<Product2> equipmentToUpsert = new List<Product2>();
        List<WarehouseData> data = WarehouseData.parse(callOutToWerehouse());
        for (WarehouseData current : data){
            equipmentToUpsert.add(new Product2(Name = current.name, Replacement_Part__c = current.replacement, Cost__c = current.cost, Current_Inventory__c = current.quantity, Lifespan_Months__c = current.lifespan, Maintenance_Cycle__c = current.maintenanceperiod, Warehouse_SKU__c = current.sku, ExternalId = current.sku));
        }

        upsert equipmentToUpsert;
        System.debug('equipment updated sucessfully');
    }

    public String callOutToWerehouse(){
        // Instantiate a new Http object
        Http h = new Http();

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        return res.getBody();
    }

}