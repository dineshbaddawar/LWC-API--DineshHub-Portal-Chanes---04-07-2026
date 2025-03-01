({  
    doInit: function(component, event, helper) {
        debugger;
        //var authcode = component.get("v.authcode");
        var SobjectrecId = component.get("v.SobjectrecId");
        component.set("v.displayMeetingSchedular", true);
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        
        today = mm + '/' + dd + '/' + yyyy;
        
        const monthNames = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"
                           ];
        
        var monthNum = parseInt(mm);
        var month = monthNames[monthNum-1] +' - '+ yyyy;
        component.set('v.CurrentMonth',month);
        helper.getDaysAndDate(component,event,helper);
        helper.GetDefaultRecord(component,event,helper);
       // helper.getTimezonevalue(component,event,helper);
        
    },
    openModel: function(component, event, helper) {
        debugger;
        component.set("v.displayMeetingSchedular", true);
    },    
    closeModel: function(component, event, helper) {
        debugger;
        var RecId=component.get("v.recordId");
        component.set('v.checkSpinner',true);
        var baseURL = component.get("v.EventOrgLeadRecordBaseURL");
        window.location.href = baseURL+RecId+'/view' ;
        component.set("v.displayMeetingSchedular", false);
    },
    getSlots: function(component, event, helper) {
        debugger;
        var date = event.getParam("selectedDate");
        var day = event.getParam("selectedDay");
        component.set("v.PassDate", date);
        var date = component.get('v.PassDate');
        var slot = component.get("v.SelSlot");
        var recIdLabel = component.get("v.recIdhardcodeId");
        // var recId = '0050B0000082G6d';   //component.get("v.recordId") removed hardcode id
        var recId = recIdLabel;
        //String RecId,String SchDate,String schday,String Slot
        component.set('v.SelDay',day);
        component.set('v.SelDate',date);
        var action = component.get("c.getAvailableSlots");
        action.setParams({
            "RecId": recId,
            "schday": day,
            "SchDate":date,
            "Slot": slot
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state == "SUCCESS") {
                {
                    component.set('v.checkSpinner',false);
                    component.set('v.showSlots',true);
                    component.set('v.availableSlots',response.getReturnValue());
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
    scheduleTeamsMeeting: function(component, event, helper) {
        debugger;
        var RecordId=component.get("v.SobjectrecId");
        //var authcode = component.get("v.authcode");
        
        var currentTimeNow = new Date().toISOString();
        var currentTimeFormatData =   new Date(currentTimeNow).toLocaleString("en-IN", { localeMatcher: "best fit", timeZoneName: "short" });
        /*
        // Meeting Start > Current Time
        if(component.get("v.StartMeetingTimeSelectedValue") < currentTimeFormatData){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'ERROR',
                message: "Start time can't be less than the current time.",
                duration:' 5000',
                key: 'info_alt',
                type: 'warning',
                mode: 'dismissible'
            });
            toastEvent.fire();
            return;
        }
        */
        /*
        // Meeting End Time > Meeting Start Time
        if(component.get("v.EndMeetingTimeSelectedValue") < component.get("v.StartMeetingTimeSelectedValue")){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'ERROR',
                message: "End time can't be less than the Start time.",
                duration:' 5000',
                key: 'info_alt',
                type: 'warning',
                mode: 'dismissible'
            });
            toastEvent.fire();
            return;
        }
       */        
        /*
        var RecipientEmail=component.get("v.recipientEmail");
        if(RecipientEmail!=null || RecipientEmail!=undefined){
            if(RecipientEmail.includes(';') || RecipientEmail.includes('+') || RecipientEmail.includes('&') || RecipientEmail.includes(':') || 
               RecipientEmail.includes(' ') || RecipientEmail.includes('/') || RecipientEmail.includes('!') || RecipientEmail.includes('?') || 
               RecipientEmail.includes('-') || RecipientEmail.includes('*')){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'ERROR',
                    message: 'We Only Accept comma For Email Separation',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            } 
        }
        if(RecipientEmail!=null || RecipientEmail!=undefined){
            var RecipientEmailArray=RecipientEmail.split(',');
            if(RecipientEmailArray.length>0){
                component.set("v.additionalAttendeeUserEmailList",RecipientEmailArray);
            }
            console.log('RecipientEmailArray--'+JSON.stringify(RecipientEmailArray));
        }
        */
        
        component.set('v.checkSpinner',true);
        var slot = component.get("v.SelSlotDuration");
        var selectedContacts = component.get("v.selectedLookUpRecords");
        if(selectedContacts == 0 || selectedContacts < 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'ERROR',
                message: 'Please Select at Least 1 Attendee!',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }
        var emailList = [];
        var emailListID = [];
        for (let i = 0; i < selectedContacts.length; i++) {
            if(selectedContacts[i].Email != null && selectedContacts[i].Email != undefined){
                emailList.push(selectedContacts[i].Email);
                emailListID.push(selectedContacts[i].Id);
            }
        }
        /*
        //Pushing Recipient Email
        if(RecipientEmailArray!=null || RecipientEmailArray!=undefined){
            if(RecipientEmailArray.length >0){
                for(let i=0;i<RecipientEmailArray.length;i++){
                    if(RecipientEmailArray[i]){
                        emailList.push(RecipientEmailArray[i]);
                    }
                }
            } 
        }
        */
        component.set("v.additionalAttendeeUserEmailList",emailList);
        console.log('emailList--'+JSON.stringify(emailList));
        component.set("v.LeadIdList",emailListID);
        var selectedId = component.get("v.LeadIdList");
        
        var today = new Date();
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        
        var startSlot = component.get("v.SelStartDate");
        var originalDateTimeStart = new Date(startSlot);
        var updatedDateTimeStart = new Date(originalDateTimeStart.getTime() + (5 * 60 * 60 * 1000) + (30 * 60 * 1000));
        var newStartTime = JSON.stringify(updatedDateTimeStart);
        var ex=new RegExp("\"","g");
        var FormatedStartime = newStartTime.replace(ex,"")
        
        var endSlot = component.get("v.SelEndDate");
        var originalDateTimeEnd = new Date(endSlot);
        var updatedDateTimeEnd = new Date(originalDateTimeEnd.getTime() + (5 * 60 * 60 * 1000) + (30 * 60 * 1000));
        var newEndTime = JSON.stringify(updatedDateTimeEnd);
        var ex=new RegExp("\"","g");
        var FormatedEndtime = newEndTime.replace(ex,"");
        var recIdLabel = component.get("v.recIdhardcodeId");
        var recId = recIdLabel;
        var description = component.get("v.Description");
        var secondEmail = component.get("v.emailOfAnotherUser");
        //,"code" : authcode
        if(description ==undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'ERROR',
                message: 'Please fill Description it is Required!',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }
        
        helper.callCreateEventLeadMethod(component,event,helper);
        
        var action = component.get("c.scheduleMeetingforUser");
        action.setParams({
            "startSlot": FormatedStartime,
            "endSlot":FormatedEndtime,
            "description":description,
            "secondEmail":emailList,
            "timezone" : component.get("v.SelectedTimeZoneName")
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state == "SUCCESS") {
                {   

                    //var redirectingurl = 'https://ecolibrium--dev.sandbox.lightning.force.com/lightning/r/' + component.get("v.objectAPIName") + '/' + RecordId + '/view';

                    //window.location.replace(redirectingurl);
                    helper.MethodcreateMultiAttendeeEvent(component,event,helper);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'SUCCESS',
                        message: 'The Meeting Link  has been Generated successfully.Check your Calender!!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.displayMeetingSchedular", false);
                    debugger;
                   // helper.UpdateLeadStatus(component, event); --> to be deleted not using.
                    var baseURL = component.get("v.EventOrgLeadRecordBaseURL");
                    component.set("v.displayMeetingSchedular", false);
                    component.set('v.checkSpinner',false);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    //window.location.href = baseURL+RecordId+'/view';
                   
                }
            }else{
                component.set('v.checkSpinner',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'ERROR',
                    message:'Something went wrong !',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                component.set("v.displayMeetingSchedular", false);
            }
        }));
        $A.enqueueAction(action);
    },
    
    ChooseSlot: function(component, event, helper) {
        debugger;
        var slot = event.currentTarget.title;
        component.set('v.SelSlotDuration',slot);
    },
    ShowMeetingSchedular :function(component, event, helper) {
        debugger;
        component.set('v.displayMeetingSchedular',false);
        component.set('v.displayMeetingSchedularChild',true);
    },
    showMeetingDetails :function(component, event, helper) {
        debugger;
        component.set('v.displayMeetingSchedularChild',false);
        component.set('v.displayMeetingDetails',true);
    },
    
    onChangeHandler : function(component, event, helper) {
        debugger;
        var meetingdatetimeStart =  component.find("datetimestart").get("v.value");
        component.set("v.meetingdatetimeStart", meetingdatetimeStart);
        var meetingdatetimeEnd =  component.find("datetimeend").get("v.value");
        component.set("v.meetingdateEnd", meetingdatetimeEnd);
    },
    onChangeStartDateTime : function(component, event, helper) {
        debugger;
        
        var StartDateTime =  component.find("StartDateTimeid").get("v.value");
        var EndDateTime =  component.find("EndStartDateTimeid").get("v.value");
        
        
        var currentTimeNow = new Date().toISOString();
        var currentTimeFormatData =   new Date(currentTimeNow).toLocaleString("en-IN", { localeMatcher: "best fit", timeZoneName: "short" });
        
        var StartMeetingSelectedTimeFormData =  new Date(StartDateTime).toLocaleString("en-IN", { localeMatcher: "best fit", timeZoneName: "short" });
        component.set("v.StartMeetingTimeSelectedValue",StartMeetingSelectedTimeFormData);
        
        var EndMeetingSelectedTimeFormData =  new Date(EndDateTime).toLocaleString("en-IN", { localeMatcher: "best fit", timeZoneName: "short" });
        component.set("v.EndMeetingTimeSelectedValue",EndMeetingSelectedTimeFormData);
        /*
        // For Start Time is greater than Current Time
        if(StartMeetingSelectedTimeFormData < currentTimeFormatData ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message:"Start time can't be less than the current time.",
                duration:' 5000',
                key: 'info_alt',
                type: 'info',
                mode: 'dismissible'
            });
            toastEvent.fire();
            return;
        }
        */
        /*
        // for End Time > Start Time
        if(EndMeetingSelectedTimeFormData < StartMeetingSelectedTimeFormData){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: "End time can't be less than the Start time.",
                duration:' 5000',
                key: 'info_alt',
                type: 'info',
                mode: 'dismissible'
            });
            toastEvent.fire();
            return;
        }
        */
        
        var StartDT = StartDateTime.substring(0,16);
        var EndDT = EndDateTime.substring(0,16);
        var milliseconds = ((new Date(EndDT)) - (new Date(StartDT)));
        
        var Startmilliseconds = (new Date(EndDT));
        var Endmilliseconds = (new Date(StartDT));
        
        let seconds = Math.floor(milliseconds / 1000);
        let minutes = Math.floor(seconds / 60);
        let hours = Math.floor(minutes / 60);
        
        if(minutes < 0){
            /*var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: 'End Time can not be less than Start Time !',
                duration:' 2000',
                key: 'info_alt',
                type: 'warning',
                mode: 'pester'
            });
            toastEvent.fire();
            return;*/
        }
        
        if(hours > 2 || minutes > 120){
            /*var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: 'Can not Creating Meeting for more 2 Hours !',
                duration:' 5000',
                key: 'info_alt',
                type: 'warning',
                mode: 'sticky'
            });
            toastEvent.fire();
            return;*/
        }
        
    },
    closeQuickAction:function(component, event, helper) {
        debugger;
        var cmpEvent = component.getEvent("sampleCmpEvent");
        cmpEvent.fire();
    },
    onChangeHandler : function(component, event, helper) {
        debugger;
        var selectedTimezone =  component.find('timezoneId').get('v.value');
        var timeZoneSlice = selectedTimezone.slice(0, -12);
        component.set("v.SelectedTimeZoneName", timeZoneSlice);
    }
    
})