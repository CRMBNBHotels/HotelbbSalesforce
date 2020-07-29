declare module "@salesforce/apex/LCC09_GeneratePasswordController.GeneratePassword" {
  export default function GeneratePassword(): Promise<any>;
}
declare module "@salesforce/apex/LCC09_GeneratePasswordController.GetListContacts" {
  export default function GetListContacts(param: {ContractId: any}): Promise<any>;
}
declare module "@salesforce/apex/LCC09_GeneratePasswordController.SendEmails" {
  export default function SendEmails(param: {listCont: any, PWD: any}): Promise<any>;
}
