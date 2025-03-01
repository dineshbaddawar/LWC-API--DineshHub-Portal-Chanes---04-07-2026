({
	helperMethodContact : function(component,event,helper) {
		component.set("v.contactColumns",[
            {label: 'Contact Name', fieldName: 'linkName', type: 'url',
             typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
             {label:'Phone', fieldName: 'Phone', type:'text'},
            {label:'Email', fieldName: 'Email', type:'email'}
        ]);
        
        var action = component.get("c.contactWithAccountId");
        var conaccountId = component.get("v.AccountId");
         console.log("conaccountId:::",conaccountId);
        
        action.setParams({
            "AccountId" : conaccountId
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            console.log("Contact State:::",State);
            var data = response.getReturnValue();
            data.forEach(function(record){
                record.linkName = '/'+record.Id;
            });
            component.set("v.conList", data);
        });
         $A.enqueueAction(action);
	}
})