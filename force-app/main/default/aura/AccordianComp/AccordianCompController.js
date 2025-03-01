({
	doInit : function(component, event, helper) {
      var action = component.get("c.getAccounts");
      
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var retunData = response.getReturnValue();
                console.log("accList retunData",retunData);
                component.set("v.accList", retunData);
                            console.log("accList retunData",retunData);
            }
            else{
                aler("Error");
            }
            console.log("State",state);
        });
         $A.enqueueAction(action);
	}
})