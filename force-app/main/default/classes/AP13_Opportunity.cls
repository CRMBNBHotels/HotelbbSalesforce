public without sharing class AP13_Opportunity {
    
    Public Static Map<Id,Opportunity> CalculateRoom(List<Opportunity> InsertOpp, List<Opportunity> DeleteOpp,List<Opportunity> UpdateOpp,map<Id,Opportunity> oldMapOpp){
        
        Map<Id,Opportunity> mapMB = new Map<Id,Opportunity>();
        
        if(InsertOpp != null && InsertOpp.size() > 0){
            
            for(Opportunity opp : InsertOpp){
                
                Opportunity oppToUpdate = new Opportunity();
                system.debug('### jka oppToUpdate'+oppToUpdate);
                system.debug('### jka opp.Master_Booking_FK__c '+opp.Master_Booking_FK__c);
                
                oppToUpdate.id =opp.Master_Booking_FK__c;
                system.debug('### jka oppToUpdate.id '+oppToUpdate.id);
                System.debug('opp.TechMBRoom__c'+opp.TechMBRoom__c);
                
                if(opp.TechMBRoom__c == null) {
                    
                    OppToUpdate.Rooms__c = 0;
                }else {
                    
                    OppToUpdate.Rooms__c =opp.TechMBRoom__c;
                }
                if(mapMB.containsKey(opp.Master_Booking_FK__c)){
                    
                    oppToUpdate = mapMB.get(opp.Master_Booking_FK__c);
                }
                
                oppToUpdate.Rooms__c = oppToUpdate.Rooms__c + opp.Chambre__c;
                mapMB.put(opp.Master_Booking_FK__c, oppToUpdate);
            }
        }
        else if(DeleteOpp != null && DeleteOpp.size() > 0){
            
            for(Opportunity opp : DeleteOpp){
                
                Opportunity oppToUpdate = new Opportunity();
                oppToUpdate.id =opp.Master_Booking_FK__c;
                
                if(opp.TechMBRoom__c == null) {
                    
                    OppToUpdate.Rooms__c = 0;
                }else {
                    
                    OppToUpdate.Rooms__c =opp.TechMBRoom__c;
                }
                if(mapMB.containsKey(opp.Master_Booking_FK__c)){
                    
                    oppToUpdate = mapMB.get(opp.Master_Booking_FK__c);
                }
                if(oppToUpdate.Rooms__c > 0 ){
                    
                    oppToUpdate.Rooms__c = oppToUpdate.Rooms__c - opp.Chambre__c;
                    mapMB.put(opp.Master_Booking_FK__c, oppToUpdate);
                }
            }
        }
        
        else if(UpdateOpp != null && UpdateOpp.size() > 0){
            
            for(Opportunity opp : UpdateOpp){
                
                Opportunity oppToUpdate = new Opportunity();
                Opportunity OldoppToUpdate = new Opportunity();
                Decimal OldChambre = 0;
                
                if(oldMapOpp.get(opp.id).Chambre__c != null){
                    
                    OldChambre = oldMapOpp.get(opp.id).Chambre__c;
                }
                if(opp.Master_Booking_FK__c != null){
                    
                    oppToUpdate.id =opp.Master_Booking_FK__c;
                }
                if(oldMapOpp.get(opp.id).Master_Booking_FK__c != null){
                    
                    OldoppToUpdate.id = oldMapOpp.get(opp.id).Master_Booking_FK__c;
                }
                if(oldMapOpp.get(opp.id).TechMBRoom__c == null){
                    
                    OldoppToUpdate.Rooms__c = 0;
                }
                else{
                    
                    OldoppToUpdate.Rooms__c =oldMapOpp.get(opp.id).TechMBRoom__c;
                }
                if(opp.TechMBRoom__c == null){
                    
                    OppToUpdate.Rooms__c = 0;
                }
                else{
                    
                    OppToUpdate.Rooms__c =opp.TechMBRoom__c;
                }
                if(OppToUpdate.id != OldoppToUpdate.id ){
                    
                    if(mapMB.containsKey(opp.Master_Booking_FK__c)){
                        
                        oppToUpdate = mapMB.get(opp.Master_Booking_FK__c);
                    }
                    if(mapMB.containsKey(oldMapOpp.get(opp.id).Master_Booking_FK__c)){
                        
                        OldoppToUpdate = mapMB.get(oldMapOpp.get(opp.id).Master_Booking_FK__c);
                    }
                    system.debug('oldMapOpp.get(opp.id).Master_Booking_FK__c' + oldMapOpp.get(opp.id).Master_Booking_FK__c);
                    if(OldoppToUpdate.Rooms__c > 0 &&  oldMapOpp.get(opp.id).Master_Booking_FK__c != null){
                        
                        system.debug('Old OPP Room before update ' + OldoppToUpdate.Rooms__c);
                        system.debug('Old OldChambre before update ' + OldChambre);
                        OldoppToUpdate.Rooms__c = OldoppToUpdate.Rooms__c - OldChambre;
                        
                        system.debug('Old OldChambre after update ' +  OldoppToUpdate.Rooms__c);
                        mapMB.put(oldMapOpp.get(opp.id).Master_Booking_FK__c, OldoppToUpdate);
                    }
                    
                    system.debug('### cg oppToUpdate.Rooms__c'+oppToUpdate.Rooms__c);
                    system.debug('### cg opp.Chambre__c'+opp.Chambre__c);
                    if(opp.Chambre__c != null){
                    
                        oppToUpdate.Rooms__c = oppToUpdate.Rooms__c + opp.Chambre__c;
                    }
                    system.debug('### cg oppToUpdate.Rooms__c'+oppToUpdate.Rooms__c);
                    
                    if(opp.Master_Booking_FK__c != null){
                        
                        mapMB.put(opp.Master_Booking_FK__c, oppToUpdate);
                    }
                }
                else{
                    
                    if(opp.Master_Booking_FK__c != null){
                        
                        if( mapMB.containsKey(opp.Master_Booking_FK__c)){
                            
                            oppToUpdate = mapMB.get(opp.Master_Booking_FK__c);
                        }
                        oppToUpdate.Rooms__c = oppToUpdate.Rooms__c - OldChambre + opp.Chambre__c;
                        mapMB.put(opp.Master_Booking_FK__c, oppToUpdate);
                    }
                }
            }
            
        }
        return mapMB;
    }
}