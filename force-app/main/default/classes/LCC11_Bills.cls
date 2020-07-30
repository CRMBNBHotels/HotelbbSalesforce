/*
* Description: Controller class for see/download bills Component => 
* @author: TMA-EI JK
* @date: 06/04/2020
* @Test class: LCC11_Bills_test
* @Coverage: 100 % 
* @Lightning Components: LC11_Bills
*/
public without sharing class LCC11_Bills {
    
    @AuraEnabled
    //Calls Lc02 and give the bills parameter, the lc02 will call the class BBUS_DataHistoryManager that performs the webservice callout 
    public static LC02_WSDataTable_Controller.ResultWrapper loadTableInformation(String pageKey, Id sfdcId) {
        LC02_WSDataTable_Controller.ResultWrapper wrapper = LC02_WSDataTable_Controller.loadTableInformation('bills',null,null,sfdcId,null);
        return wrapper;
    }
}