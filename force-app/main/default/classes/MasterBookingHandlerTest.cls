@isTest
public class MasterBookingHandlerTest {
	@isTest
    public static void testMethod1()
    {
        String masterBookingRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Master_Booking').getRecordTypeId();
        Account testAcc=Utils.CreatePersonAccount('accName',null);
        Account testAcc2=Utils.CreatePersonAccount('accName2',null);
        insert testAcc;
        insert testAcc2;
        Opportunity testOpp=Utils.CreateMasterBookingOpportunity('oppName',testAcc.id);
        testOpp.StageName=Label.StageNameBooking_Checked;
        testOpp.RecordTypeId = masterBookingRTId;
        insert testOpp;
        Account getAcc=[Select id,Total_Transactions__pc from account where id=:testAcc.id limit 1];
        //System.assertEquals(getAcc.Total_Transactions__pc, 1);
            
        List<Opportunity> listOpp=new List<Opportunity>();
        Map<id,Opportunity> mapOpp=new Map<id,Opportunity>();
        listOpp.add(testOpp);
        mapOpp.put(testOpp.id,testOpp);
        /*MasterBookingHandler.FilterOpportunity(listOpp, null);
        MasterBookingHandler.FilterOpportunity(listOpp, mapOpp);
        MasterBookingHandler.FilterOpportunity(null, mapOpp);*/
        testOpp.Person_Account__c=testAcc2.id;
        update testOpp;
        Account getAcc2=[Select id,Total_Transactions__pc from account where id=:testAcc2.id limit 1];
        //System.assertEquals(getAcc.Total_Transactions__pc, 1);
        delete testOpp;
        Account getAcc3=[Select id,Total_Transactions__pc from account where id=:testAcc2.id limit 1];
        //System.assertEquals(getAcc3.Total_Transactions__pc, 0);
    
    }
}