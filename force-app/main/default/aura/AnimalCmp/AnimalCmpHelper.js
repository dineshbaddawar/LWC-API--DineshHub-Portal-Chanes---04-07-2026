({
	getAnimalsHelper : function(component, event, helper) {
        debugger;
		var action = component.get("c.fetchAnimals");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                if(results != null){
                    component.set("v.data", JSON.parse(results).animals);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
	}
})