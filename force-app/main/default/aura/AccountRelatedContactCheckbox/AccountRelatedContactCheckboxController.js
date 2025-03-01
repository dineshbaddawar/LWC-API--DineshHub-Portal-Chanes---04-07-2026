({
    doInit : function(component, event, helper) {
          component.set("v.ShowPage", true);
        debugger;
     //   let callMethod = component.get("c.doInitDocument");
     //   $A.enqueueAction(callMethod);
        var action = component.get("c.getAccountontactCheckbox");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.contactList', result);  
                
            }
        });
        $A.enqueueAction(action);
    },
    checkboxSelect : function(component, event, helper) {
        debugger;
        var selectedaccId= document.querySelector('input[name="options"]:checked').id;   
        component.set("v.selectedRecordId" , selectedaccId);
        if(selectedaccId !=null){
            component.set("v.PreviewButton", true);
        }
    },
    handleClick : function(component, event, helper) {
        debugger;
        var action = component.get("c.getAttachmentId");
        action.setParams({
            contactId : component.get("v.selectedRecordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.PreviewButton", false);
                 component.set("v.ShowPage", false);
                component.set("v.PdfPreview", true);
                
                var data = response.getReturnValue();
                if(data !=null){
                    component.set("v.attachementId",data);
                }
            }
        });
         $A.enqueueAction(action);
    },
    
    hideQuickAction : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
  
    
})