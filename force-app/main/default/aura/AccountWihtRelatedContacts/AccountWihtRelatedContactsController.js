({
    doInit : function(component, event, helper) {
        var action =	component.get("c.AccountwithRelatedContacts");
        var currentAccountId = component.get("v.recordId");
        console.log("currentAccountId:::",currentAccountId)
        
        action.setParams({
            "accountId" : currentAccountId
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            console.log("State:::",State)
            if(State === 'SUCCESS'){
                var data = response.getReturnValue();
                 console.log("Account data:::",data);
                component.set("v.AccountId",data.Id);
                helper.helperMethodContact(component,event);
            }
        });
         $A.enqueueAction(action);
    }
})