declare module "@salesforce/apex/AP01_Opportunity.getHotels" {
  export default function getHotels(): Promise<any>;
}
declare module "@salesforce/apex/AP01_Opportunity.getAddressAutoComplete" {
  export default function getAddressAutoComplete(param: {input: any}): Promise<any>;
}
declare module "@salesforce/apex/AP01_Opportunity.getlocationlatlong" {
  export default function getlocationlatlong(param: {address: any}): Promise<any>;
}
declare module "@salesforce/apex/AP01_Opportunity.Filter" {
  export default function Filter(param: {latlong: any}): Promise<any>;
}
declare module "@salesforce/apex/AP01_Opportunity.createHotel" {
  export default function createHotel(param: {sfdcId: any, ListHotel: any, address: any}): Promise<any>;
}
