({
    showSpinner : function(component, event, helper) {
        var Spin  = component.find("spinner");
        $A.util.removeClass(Spin, "slds-hide");
    },
    hideSpinner : function(component, event, helper){
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
        
    }
})