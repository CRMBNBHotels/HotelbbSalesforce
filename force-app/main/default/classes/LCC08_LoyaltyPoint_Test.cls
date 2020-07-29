/*
* Description: Test Class for Controller class for Add/Remove Loyalty Point Component => 
* @author: TMA-EI JK
* @date: 08/04/2019
* @modiefied by: TMA-EI Cynthia Geagea 28/05/2019
* @Lightning Components: LC08_LoyaltyPoint
*/

@isTest
public class LCC08_LoyaltyPoint_Test {
	
    @isTest
    static void test_LCC08_Loyalty(){
        Account PersonAccount = Utils.CreatePersonAccount('Person', null);
        PersonAccount.Email__pc = 'Person@hotmail.com';
        PersonAccount.Externalid__c = '123';
        insert PersonAccount;
        String strResponse = '{  "bb:UpdateWalletRQ": {      "@ID": "1234",      "@Email": "good_customer@gmail.com",      "@Type": "ADD",      "@Amount": "500",      "@Reason": "Adding point for good behaviour"  }}';
        LCC08_LoyaltyPoint.GetAccountInfo(PersonAccount.id);
        LCC08_LoyaltyPoint.DoCalculation(PersonAccount.id,'Ajout',10,20, 'Echange cadeau', 'test description 1');
        LCC08_LoyaltyPoint.DoCalculation(PersonAccount.id,'Suppression',15,20, 'Echange cadeau', 'test description 2');
        LCC08_LoyaltyPoint.InsertLog( strResponse);
    }

}