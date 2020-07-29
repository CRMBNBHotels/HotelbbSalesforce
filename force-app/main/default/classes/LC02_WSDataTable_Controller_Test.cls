@isTest
public class LC02_WSDataTable_Controller_Test {
    @isTest
    static void testLoadTableInformation(){
    Id sfdcid= Null;
        LC02_WSDataTable_Controller.ResultWrapper wrapper = LC02_WSDataTable_Controller.loadTableInformation('voucher',false, '1',sfdcid,null);
    }
}