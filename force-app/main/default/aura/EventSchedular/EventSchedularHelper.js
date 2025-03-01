({
    getDaysAndDate: function(component,event,helper){
        debugger;
        var recIdLabel = component.get("v.recIdhardcodeId");
        var recId = recIdLabel;
        var action = component.get("c.getDaysAndTime");
        action.setParams({
            "RecordId": recId
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();            
            if (state == "SUCCESS") {
                {
                    if(storeResponse != null){
                        var custs = [];
                        var conts = response.getReturnValue()[0].daysAndTime;
                        for(var key in storeResponse[0].daysAndTime){
                            custs.push({value:conts[key], key:key});
                        }
                        debugger;
                        component.set('v.SelStartDate',storeResponse[0].currentdayAndTime);
                        component.set('v.SelEndDate',storeResponse[0].currentdayAndTime);
                        component.set('v.Hostname',storeResponse[0].UserName);
                        component.set('v.HostEmail',storeResponse[0].Email);
                        component.set('v.HostCut',storeResponse[0].ShortName);
                    }
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
    
    callCreateEventLeadMethod : function(component,event, helper){
        debugger;
        var action = component.get("c.createEventRecordforSelectedLead");
        var description = component.get("v.Description");
        
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
        
        var StringStartDate = FormatedStartime.substring(0,10) +' '+FormatedStartime.substring(11,19); 
        
        
        var StringEndDate = FormatedEndtime.substring(0,10) +' '+FormatedEndtime.substring(11,19);
        
        action.setParams({
            recordId : component.get("v.recordId"),
            meetingSubject : description,
            startDateTime : StringStartDate,
            endDateTime : StringEndDate
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
                if(data !=null){
                    component.set("v.eventCreatedRecordId",data);
                    // var callMultipleCreateAttendeeMethod = component.get("c.MethodcreateMultiAttendeeEvent");
                    //  $A.enqueueAction(callMultipleCreateAttendeeMethod);
                }
            } else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        $A.enqueueAction(action);
    },
    
    leadNotSelectError : function(component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'WARNING',
            message: 'Please Select at Least 1 Lead Record!',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
        
    },
    /*
    UpdateLeadStatus:function(component,event,helper){
        var action = component.get("c.UpadteLeadStatusAfterMeetingLinkGenerated");
        action.setParams({
            "LeadId": component.get("v.recordId")
        }); 
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('Lead Status Updated SucessFully'); 
            }else {
                console.log('Got Some Error'); 
            }
            
        });
        $A.enqueueAction(action);
    },
    */
    GetDefaultRecord:function(component,event,helper){
        debugger;
        var action = component.get("c.searchDefaultRecord");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "sObjectApiName":component.get("v.objectAPIName")
        }); 
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
               // component.set("v.selectedLookUpRecords",data);
            }else {
                console.log('Got Some Error');  
            } 
        });
        $A.enqueueAction(action);
    },
    
    getTimezonevalue :function(component,event,helper){
        debugger;
        var action = component.get("c.getAllTimezonList");
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data !=null){
                    component.set("v.timeZoneList",data);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    MethodcreateMultiAttendeeEvent : function(component,event,helper){
        debugger;
        var action = component.get("c.createMultipleAttendeeEvnet");
        action.setParams({
            createdeventId : component.get("v.eventCreatedRecordId"),
            additionAttendeeUserEmail : component.get("v.additionalAttendeeUserEmailList")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
})