({
	doInit : function(component, event, helper) {
        debugger;
		var key = component.get("v.key");
        var map = component.get("v.map");
        component.set("v.value", map[key]);
	}
})