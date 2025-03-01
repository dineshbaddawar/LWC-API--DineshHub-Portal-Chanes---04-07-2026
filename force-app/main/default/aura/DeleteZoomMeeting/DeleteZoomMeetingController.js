({
    doInit : function(component, event, helper) {
        debugger;
        
        
        var action = component.get("c.getZoomeetingContact");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data.Meeting_Link__c !=null){
                    component.set("v.meetingURL",data.Meeting_Link__c);
                    let callMethod = component.get("c.deleteMeetingMethod");
                    $A.enqueueAction(callMethod);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteMeetingMethod  : function(component,event, helper){
        debugger;
        var meetingId = component.get("v.meetingURL").split("j/").pop();
        var action = component.get("c.deleteMeeting");
        action.setParams({
            meetingId : meetingId,
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                let showSuccess = component.get("c.showSuccessToast");
                $A.enqueueAction(showSuccess);
                
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                $A.get('e.force:refreshView').fire();
            }else{
                alert("ERROR")
            }
        });
        $A.enqueueAction(action);
    },
    
    showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'SUCCESS',
            message: 'Meeting Link deleted Successfully !',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
})