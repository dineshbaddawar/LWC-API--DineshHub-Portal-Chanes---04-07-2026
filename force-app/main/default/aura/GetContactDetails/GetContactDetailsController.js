({
	getContactData : function(component, event, helper) {
		
        var action= component.get("c.getContactDetails");
        action.setCallback(this, function (response){
            var state = response.getState();
            if(state == 'SUCCESS'){
              var returnData = response.getReturnValue();
                component.set("v.conList", returnData);
            }
            
        });
        $A.enqueueAction(action);
	},
})