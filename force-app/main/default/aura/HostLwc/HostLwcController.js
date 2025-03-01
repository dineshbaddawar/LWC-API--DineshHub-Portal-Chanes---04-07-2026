({
	getValueFromLwc : function(component, event, helper) {
        debugger;
		component.set("v.inputValue",event.getParam('value'));
	}
})