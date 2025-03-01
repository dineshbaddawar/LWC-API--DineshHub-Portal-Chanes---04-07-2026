({
    onPageReferenceChange : function(component, event, helper) {
        debugger;
        // alert("Hi")
        var myPageRef = component.get("v.pageReference");
        var label = $A.get("$Label.c.listViewContactId");
        var Contacts = myPageRef.state.c__listofContacts;
        component.set("v.conSelectedId" ,Contacts);
        if(Contacts.length <0 || Contacts == ""){
            alert("Warning")
            helper.showWarning(component, event);
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewContactId" : label,
                "listViewName" : "All Contacts",
                "scope" : "Contact"
            });
            navEvent.fire();
        }else{
            var action = component.get("c.DeleteSelContact");
            var SelectedId = component.get("v.conSelectedId");
            action.setParams({
                "conIdSetToDel" : SelectedId
            });
            action.setCallback(this, function(response){
                var State = response.getState();
                if(State === "SUCCESS"){
                     helper.successMessage(component, event); 
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewContactId" : label,
                        "listViewName" : "All Contacts",
                        "scope" : "Contact"
                    });
                    navEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
})