trigger AfterUpdateAccount on Account (after update) {
    //AP02_Account.UpdateStayOppWhenGuestAccountUpdate(trigger.new,trigger.oldMap);
    //AP02_Account.updatePartnerShipFieldsWhenPartnerCodeChange(trigger.new,trigger.oldMap);
    //TMABNB CRMSS-96

    AP05_Account.CallWSUpdatePersonAccountInfo(trigger.newMap,Trigger.oldMap);
    
    //TMABNB CRMSS-236
    AP06_Account.TrackHistory(Trigger.new, Trigger.oldMap);
}