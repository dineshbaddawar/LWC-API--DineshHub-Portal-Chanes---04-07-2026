({
	doInit : function(component, event, helper) {
		debugger;
        var action = component.get("c.getPickListValues");
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State == 'SUCCESS'){
                var result = response.getReturnValue();
                var plValues = [];
                for(var i=0; i < result.length; i++){
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.LeadTypeList", plValues);
                console.log("plValues" ,plValues)
            }
        });
        $A.enqueueAction(action);
	},
    
    handleLeadTypeChange : function(component, event, helper) {
		debugger;
        var selectedValues = event.getParam("value");
        component.set("v.selectedLeadTypeList", selectedValues);
	},
    getSelectedLeadType : function(component, event, helper) {
		debugger;
        var selectedValues = component.get("v.selectedLeadTypeList");
	}
    
})