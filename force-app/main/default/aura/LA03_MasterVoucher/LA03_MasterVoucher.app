<!-- for testing purposes-->
<aura:application access="GLOBAL" extends="ltng:outApp" 
                  implements="ltng:allowGuestAccess">
  <!-- Create attribute to store lookup value as a sObject--> 
  <!--aura:attribute name="selectedLookUpRecord" type="sObject" default="{}"/>
  <c:LC20_DashboardOCLookupsParent objectAPIName="Account" IconName="standard:account" selectedRecord="{!v.selectedLookUpRecord}" label="Account Name"/-->
  <c:LC21_DashboardOCQuotasManagement/>
</aura:application>