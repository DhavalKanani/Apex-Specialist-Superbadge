@IsTest
private class WarehouseCalloutServiceTest{
    // implement your mock callout test here
    @isTest
    private static void positiveTestCase(){
        // Test data setup

        WarehouseCalloutService wcs = new WarehouseCalloutService();

        // Actual test
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        wcs.execute(null);


        system.assertEquals([SELECT count()
                             FROM product2], 2);
    }

}