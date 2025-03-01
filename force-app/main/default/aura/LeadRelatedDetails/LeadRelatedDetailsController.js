({
    doInit : function(component, event, helper) {
        var action = component.get("c.fetchLeadData");
        var leadId = component.get("v.recordId");
        console.log("Lead Current ID ::",leadId);
        action.setParams({
            "recId" : leadId
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            console.log("State Lead :::",State);
            if(State === 'SUCCESS'){
                var data = response.getReturnValue();
                console.log("Lead DATA ::",data);
                component.set("v.leadEmailRec", data.Email);
                console.log("Lead DATA Email ::",data.Email);
                component.set("v.leadPhoneRec", data.Phone);
                console.log("Lead DATA Phone ::",data.Phone);
                 helper.helperMethodContact(component,event); 
            }
        })
        
        $A.enqueueAction(action);
    },    
    
})