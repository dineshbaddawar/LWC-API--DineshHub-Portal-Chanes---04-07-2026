({
	helperMethod : function(component, event) {
        debugger;
		var ObjectName = "Contact";
        var FieldNameConType = "Contact_Type__c";
        var action = component.get("c.getPickListValuesMethod");
        action.setParams({
              "ObjectApi_name" : ObjectName,
            "Field_Name" : FieldNameConType
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.pickListValuesContactType", result);
            }
        });
         $A.enqueueAction(action);
	},
     showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Email Send Successfully !',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
})