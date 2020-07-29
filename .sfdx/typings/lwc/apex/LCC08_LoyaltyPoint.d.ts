declare module "@salesforce/apex/LCC08_LoyaltyPoint.GetAccountInfo" {
  export default function GetAccountInfo(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/LCC08_LoyaltyPoint.DoCalculation" {
  export default function DoCalculation(param: {accountId: any, type: any, NumberPoints: any, ApexNbPoint: any, Reason: any, Description: any}): Promise<any>;
}
declare module "@salesforce/apex/LCC08_LoyaltyPoint.InsertLog" {
  export default function InsertLog(param: {strResponse: any}): Promise<any>;
}
