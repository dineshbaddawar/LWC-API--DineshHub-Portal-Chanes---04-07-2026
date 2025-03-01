({
	doInit : function(component, event, helper) {
		
	},
    getAccounts : function(component, event, helper) {
        debugger;
        component.set("v.spinner",true);
        var action = component.get("c.getFiveAccount");
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.spinner",false);
            }
           var data = response.getReturnValue();
           
        });
          $A.enqueueAction(action);
    },
    
     // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    }
})