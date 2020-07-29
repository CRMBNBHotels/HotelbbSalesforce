public class AP01_SObject {
    public static void UpdateFromSalesforce(List<sObject> listSobject)
    {
        for(sObject obj : listSobject){
            if(!UserInfo.getUserId().contains(Label.TechnicalUserId) && obj.get('fromSalesforce__c') != true){
                obj.put('fromSalesforce__c',true);      obj.put('fromHeroku__c',false);
            }
        }
    }
}