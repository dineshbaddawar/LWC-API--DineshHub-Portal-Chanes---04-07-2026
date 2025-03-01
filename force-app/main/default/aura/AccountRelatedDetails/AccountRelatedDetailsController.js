({
    doaction : function(component, event, helper) {
        debugger;
        var action = component.get("c.getAccountRelatedRecordCounts");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.contactCount", data.contactCount);
                component.set("v.OpportunityCount", data.opportunityCount);
                component.set("v.caseCount", data.caseCount);
                component.set("v.leadount", data.leadCount);
                component.set("v.Sobjectdata", data);
            }
        });
        $A.enqueueAction(action);
    },
    
    getContactList : function(component, event, helper){
        debugger;
        var delId =  component.get("v.Sobjectdata");
        helper.InsertMethod(component, event, delId);
    },
    
     getOpportunityList : function(component, event, helper){
        debugger;
        var delId =  component.get("v.Sobjectdata");
        helper.showOpportunity(component, event, delId);
    },
    
    callCaseMethod : function(component, event, helper){
         debugger;
        var delId =  component.get("v.Sobjectdata");
        helper.showCase(component, event, delId);
    },
    
    /*
    callConnectedLead : function(component, event, helper){
        debugger;
        
        var action = component.get("c.getLeadCountRecordDetails");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data.connectedLeadList.length > 0){
                    component.set("v.isModalOpenConnectedLead", true);
                    component.set("v.connectedleadList" , data.connectedLeadList);
                }else{
                    alert("No Record Found !")
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    callEnrolledLead : function(component, event, helper){
        debugger;
        
        var action = component.get("c.getLeadCountRecordDetails");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data.enrollmentList.length > 0){
                    component.set("v.isModalEnrolledLead", true);
                    component.set("v.enrolledleadList" , data.enrollmentList);
                }else{
                    alert("No Record Found !")
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    callFollowupLead : function(component, event, helper){
        debugger;
        
        var action = component.get("c.getLeadCountRecordDetails");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data.followupList.length > 0){
                    component.set("v.isModalFollowupLead", true);
                    component.set("v.followupeadList" , data.followupList);
                }else{
                    alert("No Record Found !")
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    callNewLead : function(component, event, helper){
        debugger;
        
        var action = component.get("c.getLeadCountRecordDetails");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data.newList.length > 0){
                    component.set("v.isModalNewLead", true);
                    component.set("v.newleadList" , data.newList);
                }else{
                    alert("No Record Found !")
                }
                
            }
        });
        $A.enqueueAction(action);
    },
   */
    
    closeModel : function(component, event, helper){
        component.set("v.isModalOpenContact", false);
        component.set("v.isModalOpenOpportunity", false);
        component.set("v.isModalOpenCase", false);
        component.set("v.isModalNewLead", false);
        
    }
})