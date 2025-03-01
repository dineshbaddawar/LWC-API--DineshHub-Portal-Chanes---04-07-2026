({
	getContactRecord : function(component, event, helper) {
		component.set("v.columndata", [
            {label:'Name', fieldName: 'Name', type:'text'},
            {label:'Phone', fieldName: 'Phone', type:'text'},
            {label:'Email', fieldName: 'Email', type:'email'}
        ]);
        var action = component.get("c.fetchContactRecords");
        action.setCallback(this, function(response){
            component.set("v.contactList", response.getReturnValue());
        })
        $A.enqueueAction(action);
        
	}
})