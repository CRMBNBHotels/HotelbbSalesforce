/*
* Description: Test Class for Controller class for Invoice Component => 
* @author: TMA-EI JK
* @date: 021/04/2020
* @Lightning Components: LC11_Bills
*/

@isTest
public class LCC11_Bills_test {
@isTest
    static void test_LCC08_Loyalty(){
        Account PersonAccount = Utils.CreatePersonAccount('Person', null);
        PersonAccount.Email__pc = 'Person@hotmail.com';
        PersonAccount.Externalid__c = '123';
        insert PersonAccount;
        LCC11_Bills.loadTableInformation( null,PersonAccount.id);
    }

}