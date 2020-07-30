/*
* Description: Controller class for opportunity lightning components
* @author: Jenny Jawhar
* @date: 09/08/2017
* @Test class: AP01_Opportunity_Test
* @Lightning Components: LC01_Opportunity / LC01_Opportunity_Body 
*/
public class AP01_Opportunity {    
    //Method called on the initiation and when the value of the filter is chosen
    //on the component LC01_Opportunity_Body to get the list of hotels filtered by country
    @AuraEnabled
    public static List<Hotel__c> getHotels(){       
        return [Select Id, Commercial_Hotel_Name__c 
                From Hotel__c];
    }  
    @AuraEnabled
    public static string getAddressAutoComplete(String input) {
        list<string> listAddresses = new list<string>();
        String url = Label.AutoCompleteSite + EncodingUtil.urlEncode(input, 'UTF-8')
            + '&key='+label.AutoCompleteKey;
        HttpRequest objrequest = new HttpRequest();            
        objrequest.setEndpoint(url);
        objrequest.setMethod('GET');
        HttpResponse objresponse = new HttpResponse(); 
        if(!test.isRunningTest()){
            objresponse = new http().send(objrequest);
        }
        else{
            objresponse.setStatusCode(200);
            objresponse.setStatus(label.StatusComplete);
            objresponse.setBody(label.BodyAutoCompleteAddress);            
        }        
        if(objresponse.getStatusCode() == 200){
            return objresponse.getBody();
        }
        return null;
    }
    @AuraEnabled
    public static string getlocationlatlong(string address)
    {                
        address = address.replaceAll('\\s', '');
        HttpRequest objrequest = new HttpRequest();            
        objrequest.setEndpoint(Label.GeocodeSite+address+'&sensor=false');
        objrequest.setMethod('GET');
        objrequest.setCompressed(false);            
        objrequest.setHeader('Encoding','iso-8859-1');
        objrequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        objrequest.setTimeout(120000);//max timeout
        HttpResponse objresponse = new HttpResponse(); 
        if(!test.isRunningTest()){
            objresponse = new http().send(objrequest);
        }
        else{
            objresponse.setStatusCode(200);
            objresponse.setStatus(label.StatusComplete);
            objresponse.setBody(label.BodyLongLat);            
        }
        if(objresponse.getStatusCode() == 200){
            return objresponse.getBody();  
        }
        return null;
    }
    @AuraEnabled
    public static list<Hotel__c> Filter(string latlong){
        list<Hotel__c> listHotel =new list<Hotel__c>();                                  
        if(latlong != null && latlong!=Label.OverQueryLimit && latlong!=Label.ZeroResult){
            string[] split = latlong.split(',');
            decimal lat=decimal.valueOf(split[0]);
            decimal longit=decimal.valueOf(split[1]);            
            list<Hotel__c> listHotelLocation = [SELECT Id, Commercial_Hotel_Name__c,GPS_code__c
                                                FROM Hotel__c 
                                                WHERE DISTANCE(GPS_code__c, GEOLOCATION(:lat,:longit), 'km') < 50
                                                ORDER BY DISTANCE(GPS_code__c, GEOLOCATION(:lat,:longit), 'km')];
            if(listHotelLocation.Size()>0){
                list<Hotel__c> listHotelToUpdate = new list<Hotel__c>();
                for(Hotel__c hotel:listHotelLocation){                    
                    Location searchedLocation = Location.newInstance(lat, longit);
                    decimal distance = Location.getDistance(searchedLocation,hotel.GPS_code__c, 'km');                 
                    hotel.Distance__c = distance.setScale(2);
                    listHotelToUpdate.add(hotel);
                }
                update listHotelToUpdate; 
                listHotel = [SELECT Id, Commercial_Hotel_Name__c,Distance__c
                             From Hotel__c
                             where Id IN: listHotelToUpdate
                             Order By Distance__c];
            }
        }        
        else{
            listHotel= getHotels();
        }   
        return listHotel;              
    }
    //Method to create Opportunity_Hotel_Junction__c depending on the chosen Hotels and create an attachement containing all the infos of the chosen hotels  
    @AuraEnabled
    public static void createHotel(string sfdcId,List<Hotel__c> ListHotel,string address){
        list<Opportunity_Hotel_Junction__c> listJunctionOppHotel = new list<Opportunity_Hotel_Junction__c>();
        for(Hotel__c hotel: listHotel){
            Opportunity_Hotel_Junction__c junctionOppHotel = new Opportunity_Hotel_Junction__c();
            junctionOppHotel.Opportunity__c = sfdcId;
            junctionOppHotel.Hotel__c = hotel.Id;
            junctionOppHotel.Distance__c = hotel.Distance__c;
            junctionOppHotel.Address__c = address;
            listJunctionOppHotel.add(junctionOppHotel);
        }
        insert listJunctionOppHotel;
        
        list<Opportunity_Hotel_Junction__c> listJunction = [Select Opportunity__r.Name, Hotel__r.Commercial_Hotel_Name__c, Address__c, 
                                                            Distance__c,Hotel__r.Adress__c,Hotel__r.Country__c,Hotel__r.City__c,
                                                            Hotel__r.Region__c, Hotel__r.ZIP_code__c
                                                            From Opportunity_Hotel_Junction__c
                                                            Where Id IN: listJunctionOppHotel];
        string csv = label.ExcelHeaderLightning +'\n';
        string oppName;
        for(Opportunity_Hotel_Junction__c oppHotel: listJunction){
            oppName = oppHotel.Opportunity__r.Name;
            csv += '"' + oppName +'","'+ oppHotel.Hotel__r.Commercial_Hotel_Name__c + '","' + oppHotel.Hotel__r.Adress__c +
                + '","' + oppHotel.Hotel__r.Country__c + '","' + oppHotel.Hotel__r.City__c + '","' + oppHotel.Hotel__r.Region__c +
                '","' + oppHotel.Hotel__r.ZIP_code__c + '","' +  oppHotel.Address__c +'","' + oppHotel.Distance__c+'"\n';
        }
        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf(csv);
        attachment.Name = label.HotelsDot + oppName + label.DotCSV;
        attachment.ParentId = sfdcId; 
        insert attachment;
    }   
}