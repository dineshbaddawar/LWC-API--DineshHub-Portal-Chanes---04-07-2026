({
	selectChange : function(component, event, helper) {
		var checkComp = component.find("checkbox");
        component.set("v.toggleValue", checkComp.get("v.value"))
	}
})