({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.getAccountRelatedContactList");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State !='ERROR'){
                component.set("v.accList", response.getReturnValue());
            } 
        });
         $A.enqueueAction(action);
	}
})