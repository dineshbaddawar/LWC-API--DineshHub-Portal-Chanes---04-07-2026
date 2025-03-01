({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getAccountRecord");
        action.setParams({
            "AccountIdToPass" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                var data = response.getReturnValue();
                if(data !=null){
                    component.set("v.accData", data);
                    helper.helperMethodContact(component, event);
                }else{
                    alert("Something went wrong !")
                }  
            }
        });
        $A.enqueueAction(action);
    }
})