({
	showAccount : function(component, event, hleper) {
		debugger;
        var action = component.get("c.getAllAccountsList");
        // Setting up the 	Callback
        var self = this;
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State != 'ERROR'){
                component.set("v.accountOption", response.getReturnValue());
                console.log("accountOption ::"+response.getReturnValue());
            }
        });
         $A.enqueueAction(action);
	},
    
    showContact : function(component, event, helper){
        debugger;
        var selAccId = component.get("v.selectedAccount");
        var action = component.get("c.getAccountRelatedContacts");
        action.setParams({
            "AccId" : selAccId
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State != "ERROR"){
                component.set("v.contactOption", response.getReturnValue());
                console.log("contactOption ::"+response.getReturnValue());
            }
        });
         $A.enqueueAction(action);
    },
    
    showContactSelected : function(component, event, helper){
        debugger;
        var sleContactId = component.get("v.selectedContact");
    }
})