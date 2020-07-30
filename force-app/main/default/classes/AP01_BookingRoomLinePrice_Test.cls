@isTest
private class AP01_BookingRoomLinePrice_Test {
    public static testmethod void DeleteBookingRoomLinePrice_Test(){
        Account newAcc = new Account();
        newAcc = utils.CreatePersonAccount('test Account 1',null);
        insert newAcc;
        Opportunity newMB = new Opportunity();
        newMB = utils.CreateMasterBookingOpportunity('test Master Booking 1',newAcc.id);
        insert newMB;
        Opportunity newB = new Opportunity();
        newB = utils.CreateBookingOpportunity('test Booking 1');
        newB.stageName = label.ClosedWonStage;
        newB.Master_Booking_FK__c = newMB.id;
        insert newB;
        Booking_Room_Line__c newBRL = new Booking_Room_Line__c();
        newBRL = utils.CreateBookingRoomLine(newB.id);
        insert newBRL;
        Booking_Room_Line_Price__c newBRLP = new Booking_Room_Line_Price__c();
        newBRLP = utils.CreateBookingRoomLinePrice(newBRL.id,123);
        insert newBRLP;
        newBRLP.ToDelete__c = true;
        update newBRLP;
        newBRL.ToDelete__c = true;
        update newBRL;
        Booking_room_code__c newBRC = new Booking_room_code__c();
        newBRC.Booking_FK__c = newB.id;
        insert newBRC;
        newBRC.ToDelete__c = true;
        update newBRC;
    }
}