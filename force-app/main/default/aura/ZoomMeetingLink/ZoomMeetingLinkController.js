({
    doInit : function(component, event, helper) {
        debugger;
        let callmethod = component.get("c.onChangeHandler");
        $A.enqueueAction(callmethod);
    },
    
    onChangeHandler : function(component, event, helper) {
        debugger;
        var meetineNamValue = component.find("name").get("v.value");
        component.set("v.meetingSubject", meetineNamValue);
        var meetingdatetime =  component.find("datetime").get("v.value");
        component.set("v.meetingdatetime", meetingdatetime);
        var meetingduration = component.find("duration").get("v.value");
        component.set("v.meetingtime", meetingduration);
    },
    
    Save : function(component, event, helper){
        debugger;
        if(component.get("v.meetingSubject") == undefined && component.get("v.meetingSubject") == null){
            alert("Please Enter Topic Name")
        }
        var action = component.get("c.createMeeting");
        action.setParams({
            "Subject" : component.get("v.meetingSubject"),
            "startSlot" : component.get("v.meetingdatetime"),
            "Duration" : component.get("v.meetingtime"),
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                let result = response.getReturnValue();
                if(result !=null){
                    let ToastMessage = component.get("c.showInfo");
                    $A.enqueueAction(ToastMessage);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    $A.get('e.force:refreshView').fire();
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    showInfo : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'SUCCESS',
            message: 'Meeting Link Created Successfully !',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },

    cancelFile: function (component, event, helper) { 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
})