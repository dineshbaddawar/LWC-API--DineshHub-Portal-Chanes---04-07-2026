({
	fetchPicklistValues : function(component, event, helper) {
		var action= component.get("c.getAccRatings");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var mapValues = response.getReturnValue();
                component.set("v.mapPicklistValues", mapValues);
                let picklistValuesList = [];
                for(let key in mapValues){
                    picklistValuesList.push(mapValues[key]);
                }
                component.set("v.picklistValues", picklistValuesList);
            }
        });
        $A.enqueueAction(action); 
	},
    
    handleSelected : function(component, event, helper){
        let currentValue = event.target.value;
        let mapValues = component.get("v.mapPicklistValues");
        let selectedValue;
        for(let key in mapValues){
            if(currentValue == mapValues[key]){
                selectedValue = key;
                break;
            }
        }
        component.set("v.selectedValue", selectedValue);
    },
})