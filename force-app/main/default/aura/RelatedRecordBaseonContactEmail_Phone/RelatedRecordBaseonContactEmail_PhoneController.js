({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.getContactData");
        var currentRecId = component.get("v.recordId");
        console.log("currentRecId::",currentRecId);
        
        action.setParams({
            "contactId" : currentRecId
        });
        
        action.setCallback(this, function(response){
            var State = response.getState();
            console.log("State::",State);
            if(State === 'SUCCESS'){
                var data = response.getReturnValue();
                console.log("Contact data::",data);
                var contactEmail = data.Email;
                console.log("contactEmail data::",contactEmail);
                var contactPhone = data.Phone;
                component.set("v.conEmail",contactEmail);
                component.set("v.conPhone",contactPhone);
                 helper.helperMethodOpportunity(component,event);
            }
        });
         $A.enqueueAction(action);
	}
})