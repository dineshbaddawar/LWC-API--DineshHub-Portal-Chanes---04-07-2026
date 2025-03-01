/**
* @author [Dinesh Baddawar]
* @email dinesh.b@utilitarianLab.com
* @create date 2024-03-11 18:13:07
* @modify date 2024-03-11 18:13:07
* @desc [description]
*/

public class EventSchedularHelper {
    
    @AuraEnabled 
    public Static List<wrapUser> getDaysAndTime(String RecordId){
        try{
            RecordId = userinfo.getUserId();        
            Map<String, String> daysWithDate = new Map<String, String>();
            Datetime dt = System.today();
            string currentDt = string.valueOf(dt);
            string currentdayAndTime = currentDt.substring(0,10)+'T'+currentDt.substring(11,13)+':00:00Z';
            string endDayAndTime = currentDt.substring(0,10)+'T'+currentDt.substring(11,13)+':00:00Z';
            USer us = [select firstName,Email,lastName,Name from user where id = :RecordId];
            String name = us.Name;
            String Email = us.Email;
            String ShortName = us.FirstName.substring(0,1) + us.LastName.substring(0,1);
            List<wrapUser> wrapUserList = new List<wrapUser>();
            wrapUserList.add(new wrapUser(currentdayAndTime,name,ShortName,Email));
            return wrapUserList;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null; 
        }
    }
    
    //=========================================================================================================================================================================================================
    // Method for Creating Meeting Link
    @AuraEnabled 
    public Static String scheduleMeetingforUser(String startSlot,String endSlot,String description,List<String> secondEmail,String timezone){ 
        System.debug('timezone == >'+timezone+' && startSlot == >'+startSlot+' && endSlot === >'+endSlot+' && description === >'+description+' && secondEmail');
        String RedirectingLink ;
        try{
            string emails='';
            for(String str:secondEmail){
                emails = str+','+emails;
            }
            emails = emails.removeEnd(',');
            system.debug('emails === >'+emails);
            String slot = startSlot.substring(11,16) +':' + endSlot.substring(11,16);
            OutlookIntegration.GenerateEventLinkwithNewFlow(emails,description,Slot,startSlot.substring(0,10),timezone);
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return RedirectingLink = 'SUCCESS';
    } 
    
    //=========================================================================================================================================================================================================
    
    @AuraEnabled
    Public Static String createEventRecordforSelectedLead(String recordId,String meetingSubject,String startDateTime,String endDateTime){ 
        System.debug('recordId ===>' +recordId + ' &&  meetingSubject  == >'+ meetingSubject + ' && startDateTime ==> '+ startDateTime + ' && endDateTime ==>'+ endDateTime);
        try{
            String createdEventId;
            List<Lead> ledList = new List<Lead>();
            if(!String.isBlank(recordId) && !String.isBlank(meetingSubject) && !String.isBlank(startDateTime) && !String.isBlank(endDateTime)){
                ledList = [SELECT Id,Name,Email FROM Lead WHERE Id=:recordId];
                for(Lead led: ledList){
                    Event objEvent = new Event();
                    objEvent.Type = 'Email';
                    objEvent.Subject = meetingSubject;
                    objEvent.StartDateTime = DateTime.valueOf(startDateTime.replace('T', ' '));
                    objEvent.EndDateTime = DateTime.valueOf(endDateTime.replace('T', ' '));
                    objEvent.WhoId	 = led.Id;
                    insert objEvent;
                    System.debug('objEvent Insert === >'+objEvent);
                    createdEventId = objEvent.Id;
                    System.debug('createdEventId ID == >'+createdEventId);
                }
                return createdEventId;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return 'ERROR';
        }
        return null;
    }
    
    //=========================================================================================================================================================================================================
    
    public class wrapUser {
        @AuraEnabled
        public  String currentdayAndTime {get; set;}
        @AuraEnabled
        public String UserName {get; set;}
        @AuraEnabled
        public String Email {get; set;}
        @AuraEnabled
        public String ShortName {get; set;}
        
        public wrapUser(String currentdayAndTime,String UserName,String ShortName,String Email ) {
            this.currentdayAndTime = currentdayAndTime;
            this.Email = Email;
            this.UserName = UserName;
            this.ShortName = ShortName;
        }
    }
    
    //=========================================================================================================================================================================================================
    
    @AuraEnabled
    public static sObject searchDefaultRecord(string recordId , string sObjectApiName) {
        string sRecId = recordId;    
        string sQuery = 'Select Id,Name,Email From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
        for (sObject obj: database.query(sQuery)) {
            return obj;
        }
        return null;
    }
    
    //=========================================================================================================================================================================================================
    
    /*
// Method fors Getting All Time Zone
@AuraEnabled 
Public static List<String> getAllTimezonList(){
List<Time_Zone_PickList__mdt> timzoneList = new List<Time_Zone_PickList__mdt>();
List<String> TimezoneNameList = new List<String>();
try{
timzoneList = [SELECT Id,MasterLabel,Squence_No__c,Country_With_TimeZone__c FROM Time_Zone_PickList__mdt ORDER BY Squence_No__c ASC];
if(!timzoneList.isEmpty() && timzoneList.size()>0){
for(Time_Zone_PickList__mdt timezone : timzoneList){
TimezoneNameList.add(timezone.Country_With_TimeZone__c);
}
if(!TimezoneNameList.isEmpty() && TimezoneNameList.size()>0){
System.debug('TimezoneNameList== >'+TimezoneNameList);
return TimezoneNameList;
}
}
}catch(Exception e){
System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
}
return null;
}
*/
    //=========================================================================================================================================================================================================
    // Method for Creating Multiple attendee
    @AuraEnabled 
    public static string createMultipleAttendeeEvnet(string createdeventId,List<String> additionAttendeeUserEmail){
        System.debug('Event Id === >'+createdeventId);
        System.debug('additionAttendeeUserEmail  === >'+additionAttendeeUserEmail);
        List<String> filteredEmailList = new List<String>();
        List<EventRelation> EventRelListToInsert = new List<EventRelation>();
        EventRelation Attendee = new EventRelation();
        List<User> attendeeUserList = new List<User>();
        Set<Id> userIdSet = new Set<Id>();
        if(additionAttendeeUserEmail.size()>0){
            for(String str : additionAttendeeUserEmail){
                if(str !=null){
                    filteredEmailList.add(str);
                }
            }
        }
        try{
            if(filteredEmailList.size()> 0 && String.isNotBlank(createdeventId)){
                attendeeUserList = [SELECT Id,username,Email FROM User WHERE Email IN:filteredEmailList];
                System.debug('attendeeUserList === >'+attendeeUserList);
                if(attendeeUserList.size()>0){
                    for(User use : attendeeUserList){
                        userIdSet.add(use.id);
                    }
                }
                System.debug('userIdSet == >'+userIdSet);
                if(userIdSet.size()>0){
                    for(Id str : userIdSet){
                        Attendee = new EventRelation();
                        Attendee.eventId = createdeventId;
                        Attendee.RelationId = str;//additional attendee
                        EventRelListToInsert.add(Attendee);
                    }
                    if(EventRelListToInsert.size()>0){
                        Database.SaveResult[] srList = Database.insert(EventRelListToInsert, false);
                        System.debug('Event Insert == >'+srList);
                        return 'SUCCESS';
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    
}