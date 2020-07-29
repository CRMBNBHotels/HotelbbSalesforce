trigger BeforeUpdate on toDelete__c (after insert) {

    /*List<toDelete__c> todelete = new List<toDelete__c>();
    for(toDelete__c obj :trigger.new){
        if(obj.delete_me__c)
        {
            toDelete__c temp = new toDelete__c();
            temp.id = obj.id;
            todelete.add(temp);
        }
    }
    delete todelete;*/
    //trigger.new[0].todelete__c = 'this is a test 1';
    system.debug('trigger.new[0]' + trigger.new[0]);
    toDelete__c temp = new toDelete__c();
    temp.id = trigger.new[0].id;
    temp.todelete__c = 'this is a test 1';
    update temp;
    
}