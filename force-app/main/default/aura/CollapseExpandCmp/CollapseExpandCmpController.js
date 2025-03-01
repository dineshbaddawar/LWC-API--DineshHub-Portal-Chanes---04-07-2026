({
	ToggleCollapse : function(component, event, helper) {
		var existingText = component.get("v.collapaseText");
        var container = component.find("containerCollapsable");
        
        if(existingText === "HidePage"){
            component.set("v.collapaseText", "ShowPage");
            $A.util.toggleClass(container, 'hide');
        }else{
            component.set("v.collapaseText", "HidePage");
            $A.util.toggleClass(container, 'hide');
        }
	}
})