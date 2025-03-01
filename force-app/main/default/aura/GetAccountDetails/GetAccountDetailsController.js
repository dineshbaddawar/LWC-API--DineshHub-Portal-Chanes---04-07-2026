({
    getAccRecord : function(component, event, helper){
        var action = component.get("c.getAccountDeatails");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var returnvalue = response.getReturnValue();
                component.set("v.getdatalist", returnvalue);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    OpencreateRecordBox : function(component, event, helper){
        component.set("v.isShowCreateAccountDialogbox", true);
    },
    
    createAccount : function(component, event, helper){
        component.set("v.isShowCreateAccountDialogbox", false);
        component.set("v.editForm", false);
    },
    
    
    
    createNewAccount : function(component, event, helper){
        var name= component.find("accName").get("v.value");
        var phone =  component.find("accPhone").get("v.value");
        var action = component.get("c.insertAccount");
        // Setting param in the apex method
        action.setParams({ 'accName' : name, 'accPhone' : phone});
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
                component.set("v.isShowCreateAccountDialogbox", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    editAccount : function(component, event, helper){
        component.set("v.isShowCreateAccountDialogbox", true);
        component.set("v.editForm", true);
        
        var accId = event.currentTarget.dataset.accid;
        var action = component.get("c.getAccountByAccId");
        component.set("v.accountId", accId);
        action.setParams({'Id' : accId});
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.getAccount", response.getReturnValue());
            }
            
        });
        $A.enqueueAction(action);
    },
    
    updateAccount : function(component, event, helper){
        var name = component.find("editName").get("v.value");
        var phone = component.find("editPhone").get("v.value");
        var site = component.find("editSite").get("v.value");
        var accID = component.get("v.accountId");
        
        var action = component.get("c.updateAccountRecords");
        action.setParams({'accName' : name, 'accPhone' : phone, 'accSite' : site, 'accID1' : accID});
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                  $A.get('e.force:refreshView').fire();
                component.set("v.isShowCreateAccountDialogbox", false);
                 component.set("v.editForm", false);
            }
        });
         $A.enqueueAction(action);
    }
    
})