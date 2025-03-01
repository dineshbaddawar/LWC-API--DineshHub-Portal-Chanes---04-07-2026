Public class ZoomApis {
    public String bodyprint{get;set;}
    public String pswrd{get;set;}
    
    @AuraEnabled
    public  Static String createMeeting(String Subject,String startSlot,Decimal Duration, String recordId) {
        // ZoomApis.createMeeting('zoom Test 1','2023-01-19T16:54:14Z',1);
        System.debug('Subject---->>> :'+Subject +' && startSlot --->>>:'+startSlot+' && Duration --->>> :'+Duration );
        try{
            if(!String.isBlank(Subject) && !String.isBlank(startSlot) && !String.isBlank(recordId)){
                Zoom_Api__c Zoom_Details = [Select id,Endpoint_URL__c,JWT_Token__c from Zoom_Api__c];
                system.debug('startSlot ---->>'+startSlot+' & Duration ----->>'+startSlot);
                ZoomApis.createMeetingWapper newWapper = new ZoomApis.createMeetingWapper();
                newWapper.topic = Subject;
                newWapper.type = 2;
                newWapper.start_time = startSlot;//'2021-04-21T16:54:14Z';
                newWapper.duration = integer.valueOf(Duration);
                newWapper.timezone = 'Asia/Kolkata';
                string jsonString = JSON.serialize(newWapper);
                // System.debug('jsonString >>'+jsonString); 
                
                String endPoint = Zoom_Details.Endpoint_URL__c;
                // System.debug('endPoint :::'+endPoint);
                //  System.debug('JWT_Token__c :::'+Zoom_Details.JWT_Token__c);
                HttpRequest req = new HttpRequest();
                req.setBody(jsonString);
                req.setMethod('POST');
                req.setHeader('Content-type', 'application/json');
                req.setHeader('Authorization', 'bearer '+Zoom_Details.JWT_Token__c);
                req.setEndpoint(endPoint); 
                Http http = new Http();
                HttpResponse res = http.send(req);
                
                if(res.getStatusCode() == 201){
                    Contact con = [SELECT Id,Name,Meeting_Link__c FROM Contact WHERE ID =: recordId LIMIT 1];
                    if(con.Meeting_Link__c == null){
                        ZoomResponseWrapper respWrapObj = ZoomResponseWrapper.parse(res.getBody());
                        if(respWrapObj.join_url !=null){
                            con.Meeting_Link__c = respWrapObj.join_url;
                            update con;
                            System.debug('Updated Contact Record :'+con);
                        }
                        //  System.debug('Meeting Link >>>' +respWrapObj.join_url);
                        // System.debug('res pass >>>' +res.getBody()); 
                        System.debug('Apex Return Data ::' +respWrapObj.join_url);
                        return respWrapObj.join_url;
                    }
                    
                    
                }else{
                    System.debug('res fail >>>' +res.getBody());
                    return 'res.getBody()'; 
                }
            }
        }catch(Exception e){
            System.debug('Error Message :'+e.getMessage() + '& Error Line :'+e.getLineNumber());
        }
        
        return null;
    }
    
    @AuraEnabled
    public Static String deleteMeeting(String meetingId,String recordId){
        // ZoomApis.deleteMeeting('87122933309');
        try{
            Zoom_Api__c Zoom_Details = [Select id,Endpoint_URL__c,JWT_Token__c from Zoom_Api__c];
            String MeetingIdToDeleteEndPointURL = Label.MeetingEndURL+meetingId;
            System.debug('MeetingIdToDeleteEndPointURL ::'+MeetingIdToDeleteEndPointURL);
            HttpRequest req = new HttpRequest();
            req.setMethod('DELETE');
            req.setHeader('Content-type', 'text/plain');
            req.setHeader('Authorization', 'bearer '+Zoom_Details.JWT_Token__c);
            req.setEndpoint(MeetingIdToDeleteEndPointURL); 
            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug('Status Code ::'+res.getStatusCode());
            System.debug('res.getBody() ::'+res.getBody());
            if(res.getStatusCode() == 204){
                System.debug('Meeting Delete Successfullly');
                Contact con = new Contact();
                con.Id = recordId;
                con.Meeting_Link__c = null;
                update con;
                System.debug('Deleted Meeting Link Contact Recrord :'+con);
            }
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('Error ::'+e.getMessage() + '&& Error Line No ::'+e.getLineNumber());
        }
        return 'ERROR';
    }
    
    @AuraEnabled
    public static Contact deleteZoomLink(String recordId){
        Contact con = new Contact();
        con.Id = recordId;
        con.Meeting_Link__c = null;
        update con;
        System.debug('Contact Record :'+con);
        return con;
    }
    
    public class createMeetingWapper{
        Public String topic {get;set;}
        Public Integer type {get;set;}
        Public String start_time {get;set;}
        Public Integer duration {get;set;}
        Public String timezone {get;set;}
        Public String password {get;set;}
    }
    
    @AuraEnabled
    public Static String createMeetingLinkUsingAura(String meetingName, String meetingdatetime, Decimal meetingduration, String recordId){
        try{
            
            if(!String.isBlank(meetingName) && !String.isBlank(meetingdatetime) && !String.isBlank(String.valueOf(meetingduration)) && !String.isBlank(recordId)){
                
                return 'SUCCESS';
            }else{
                return 'ERROR';
            }
            
            
        }catch(Exception e){
            System.debug('Error Message :'+e.getMessage() + ' & Error Line :'+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    public Static Contact getZoomeetingContact(String recordId){
        if(!String.isBlank(recordId)){
            Contact con = [SELECt Id,Name,Meeting_Link__c FROM Contact WHERE ID =:recordId AND Meeting_Link__c !=null];
            System.debug('Zoom Meeting Link Contact Record :'+con);
            return con;
        }
        return null;
    }
    
}