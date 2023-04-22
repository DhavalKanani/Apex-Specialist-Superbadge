@isTest
public class WarehouseSyncScheduleTest{
    @isTest
    static void WarehousescheduleTest(){

        String scheduleTime = '00 00 01 * * ?';
        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock();
        WarehouseSyncSchedule sync = new WarehouseSyncSchedule();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);

        String jId = System.schedule('Warehouse Time To Schedule to Test', scheduleTime, sync);

        Test.stopTest();

        CronTrigger info = [SELECT Id
                            FROM CronTrigger
                            where NextFireTime > today];
        System.assertEquals(jId, info.Id, 'Schedule ');
    }

}