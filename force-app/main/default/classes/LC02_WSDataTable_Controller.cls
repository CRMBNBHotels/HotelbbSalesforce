/*
* Description: Controller class for webservice data table lightning component => 
* @author: Georges Hobeika
* @date: 21/02/2019
* @Test class: LC02_WSDataTable_Controller_Test
* @Lightning Components: LC02_WSDataTable
*/
public without sharing class LC02_WSDataTable_Controller {
    @AuraEnabled
    public static ResultWrapper loadTableInformation(String bbObjectName, boolean includePaging, String pageKey, Id sfdcId, String PageDateKey) {
        system.debug('### pageKey ' + pageKey);
        system.debug('### includePaging ' + includePaging);
        ResultWrapper wrapper = new ResultWrapper();
        try {
            system.debug('##### sfdcId ' + sfdcId);
            wrapper.tableWrapper = BBUS_DataHistoryManager.callBBUSWebservice(bbObjectName, includePaging, pageKey, sfdcId,null,PageDateKey);
            system.debug('##### ' + wrapper);
        }catch(Exception e) {
            wrapper.isSuccess = false;
            wrapper.strErrorMsg = e.getMessage();
              wrapper.tableWrapper= new DataTableWrapper();
        }
        system.debug('### wrapper.tableWrapper' + wrapper.tableWrapper);
        return wrapper;
    }
    
    public class ResultWrapper {
        @AuraEnabled public Boolean isSuccess {get;set;}
        @AuraEnabled public String strErrorMsg {get;set;}
        @AuraEnabled public DataTableWrapper tableWrapper {get;set;}
        ResultWrapper() {
            isSuccess = true;
        }
    }    
}