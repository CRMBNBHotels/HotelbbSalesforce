/*
* This class is only used to force error on booking delete to cover test class Batch01_CleanDataHistory_Test
* @author: Georges Hobeika
* @date: 43/01/2019
* @Test: Batch01_CleanDataHistory_Test
*/

public without sharing class AP06_Opportunity {

    public static void forceErrorOnBookingDelete(List<Opportunity> listOpportunities) {
        if(Test.isRunningTest()) {
            for(Opportunity booking : listOpportunities) {
                if(booking.Name.equals('todelete')) {
                     booking.addError('Could not delete Opportunity');
                }
            }
        }
    }
}