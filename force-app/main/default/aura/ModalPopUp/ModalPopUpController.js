({
	doinit : function(component, event, helper) {
		var accId = component.get("v.accId");
        var action = component.get("c.fetchContactList");
        action.setParams({'accountId' : accId});
        action.setCallback(this, function(response){
            component.set("v.fetchContact", response.getReturnValue());
        });
           $A.enqueueAction(action);
	},
    
    closeModel : function(component, event, helper){
        component.set("v.isModelOpen", false);
    },
    
    openModel : function(component, event, helper){
        component.set("v.isModelOpen", true);
    },
    submitDetails : function(component, event, helper){
         component.set("v.isModelOpen", false);
    },
    
})