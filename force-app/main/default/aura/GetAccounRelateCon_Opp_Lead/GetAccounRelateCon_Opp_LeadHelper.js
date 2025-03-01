({
    helperMethodContact : function(component,event,helper) {
        debugger;
        var action = component.get("c.getAccountRelatedContact");
        action.setParams({
            "AccId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State ==="SUCCESS"){
                var result = response.getReturnValue();
                if(result !=null){
                    component.set("v.conData", result);
                  //  this.HelperMethodOpportunity(component,event);
                }else{
                    alert("No Contact Record Found")
                }
                
            }
        });
        $A.enqueueAction(action);
    }, 
    
    HelperMethodOpportunity : function(component,event){
        debugger;
        var action = component.get("c.getAccountRelatedOpportunity");
        action.setParams({
            "accId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var data = response.getReturnValue();
                if(data !=null){
                    component.set("v.oppData", data);
                   // this.HelperMethodLead(component, event);
                }   
            }
        });
        $A.enqueueAction(action);
    },
    
    HelperMethodLead : function(component,event){
        debugger;
        var action = component.get("c.getOpportunityRelatedLead");
        action.setParams({
            "OppId" : component.get("v.oppId")
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State != 'ERROR'){
                var result = response.getReturnValue();
                component.set("v.leadData", result);
            }
        });
        $A.enqueueAction(action);
    }
})