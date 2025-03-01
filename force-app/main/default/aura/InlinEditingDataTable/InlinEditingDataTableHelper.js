({
    fetchData: function (component,event,helper) {
        var action = component.get("c.getOpportunity");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set('v.data',data);
            }
        });
        $A.enqueueAction(action);
    },
    
    showSuccessToast: function(component,event){
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Record Updated Successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();    
    }
})