({
	doInit : function(component, event, helper) {
        debugger;
		//alert("Hi")
		var action = component.get("c.fetchRecordTypeValues");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State !='ERROR'){
                component.set("v.RecordTypeList", response.getReturnValue());
            }
        })
         $A.enqueueAction(action);
	},
    
    createRecord : function(component, event, helper){
        debugger;
        component.set("v.isOpen", true);
        var action = component.get("c.getRecordTypeId");
        var recordTypeLabel = component.find("selectid").get("v.value");
        action.setParams({
            "recordTypeLabel": recordTypeLabel
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State !='ERROR'){
                var createRecordEvent = $A.get("e.force:createRecord");
                var RecTypeID = response.getReturnValue();
                createRecordEvent.setParams({
                    "entityApiName" : 'Lead',
                    "recordTypeId" : RecTypeID
                });
                createRecordEvent.fire();
            } else if(State == "INCOMPLETE"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title" : "Opps!",
                    "message" :  "No Internet Connection"
                });
                toastEvent.fire();
            } else if(State == 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title" : "Error !",
                    "message" : "Please Contact your Administrator"
                });
                
            }
        })
         $A.enqueueAction(action);
    },
    
    openModal : function(component, event, helper){
        alert("Open Model")
        component.set("v.isOpen", true);
    },
    
    closeModal : function(component, event, helper){
        alert("Close Model")
        component.set("v.isOpen", false);
    }
})