({
	getPlayerMap : function(component, event, helper) {
        debugger;
		var action = component.get("c.FetchMapValues");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                var arrayMap = [];
                var result = response.getReturnValue();
                //Set the store response[map] to component attribute, which name is map and type is map.
                component.set("v.playerMap", result);
                for(var key in result){
                    arrayMap.push(key);
                }
                //Set the list of keys.
                component.set("v.keyList", arrayMap);
            }
        });
         $A.enqueueAction(action);
	}
})