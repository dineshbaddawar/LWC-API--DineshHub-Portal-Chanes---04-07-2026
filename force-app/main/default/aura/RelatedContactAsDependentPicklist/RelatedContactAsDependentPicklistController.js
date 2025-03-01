({
	doInIt : function(component, event, helper) {
		helper.showAccount(component, event, helper);
	},
    
    changeAction : function(component, event, helper){
        helper.showContact(component, event, helper);
    },
    contactAction : function(component, event, helper){
        helper.showContactSelected(component, event, helper);
    }
})