({
	getAccData : function(component, event, helper) {
        var action = component.get("c.getAccountDeatails");
        action.setCallback(this, function(response){
            var State = response.getState(); 
            if(State == 'SUCCESS'){
                var returnData = response.getReturnValue();
                component.set("v.accList", returnData);
            }
        });
         $A.enqueueAction(action);
       
		
	}
})