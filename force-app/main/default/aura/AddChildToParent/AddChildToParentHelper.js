({
    getChildRecors : function(component, event) {
         debugger;
   
    var action = component.get("c.getContacts");
    action.setCallback(this, function(response){
        var state = response.getState();
        if(state === 'SUCCESS'){
            // Set response value in ChildRecordList attribute on component
            component.set("v.childRecordList", response.getReturnValue());
        }
    });
    $A.enqueueAction(action);
    },

    addSelectedHelper : function(component, event, childRecordsIds){
         debugger;
        // Calling Apex method 
        var action = component.get("c.addParentAccount");
        // Passing all the selected child records Id and Parent Record Id
        // (ID of the currently displaying record[context record]) to apex method. 
        // We don’t need to add a recordId attribute to a component yourself.
        // It's automatic created with implements force:hasRecordId interface.###
        action.setParams({
            "parentId" : component.get("v.recordId"),
            "listofContactsId" : childRecordsIds
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                 // This standard 'e.force:refreshView' and 'e.force:showToast' event not work from lightning appliation
                 // Displaying SUCCESS Message
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                    "title" : "SUCCESS !",
                    "message" : "The Child Record's has been added Successfully.",
                    mode: 'pester',
                    type: 'success'
                 });
                 toastEvent.fire();

                  // refresh/reload the page view
                $A.get('e.force:refreshView').fire();
                
                // call init function again [clear selected checkboxes]
                this.getChildRecors(component,event);
            }
        });
        $A.enqueueAction(action);
    }
})