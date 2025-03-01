({
	loadData : function(component, event, helper) {
        debugger;
		var action = component.get("c.getDataFromWrapper");
        action.setCallback(this, function(response){
         var State = response.getState(); 
            if(State != 'ERROR'){
                component.set("v.wrapperList", response.getReturnValue()); 
            }
        });
         $A.enqueueAction(action);
	}
})