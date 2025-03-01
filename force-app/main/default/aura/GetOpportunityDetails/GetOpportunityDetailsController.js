({
	getOppData : function(component, event, helper) {
        var action = component.get("c.getOppDetails");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State == 'SUCCESS'){
                var returnData = response.getReturnValue();
                component.set("v.oppList", returnData);
                 //  alert(returnData);   
            }
                  //  alert(State);            
        })
        $A.enqueueAction(action);
      
	}
})