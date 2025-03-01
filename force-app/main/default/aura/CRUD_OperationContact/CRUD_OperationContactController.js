({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getContactList");
        action.setCallback(this, function(response){
            var State = response.getState();
            var data = response.getReturnValue();
            component.set("v.conList", data);
        });
        $A.enqueueAction(action);
    },
    openCreateContactModel : function(component, event, helper) {
        //  alert("Hello World")
        component.set("v.CreateContactModel", true);
    },
    closeModelCreateContact : function(component, event, helper) {
        component.set("v.CreateContactModel", false);
        component.set("v.editForm", false);
    },
    createContact : function(component, event, helper){
        debugger;
        var firstNameJs = component.find("firstName").get("v.value");
        var lastNameJs = component.find("lastName").get("v.value");
        var phone = component.find("phone").get("v.value");
        var email = component.find("email").get("v.value");
        var action = component.get("c.insertCon");
        action.setParams({'firstName' : firstNameJs, 'lastName' : lastNameJs, 'phoneNo' : phone, 'emailId' : email});
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                  helper.showCreateSuccess(component,event);
                $A.get('e.force:refreshView').fire();
              //  alert('Record Inserted!');
               
                component.set("v.CreateContactModel", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    editContact : function(component, event, helper){
        debugger;
        var selConId = event.currentTarget.dataset.conid;
        component.set("v.currentConId", selConId);
        component.set("v.CreateContactModel", true);
        component.set("v.editForm", true);
        var action = component.get("c.getContactById");
        action.setParams({
            "conId" : selConId
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                component.set("v.getContact", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    updateContact : function(component, event, helper){
        debugger;
        //   alert("Update Contact")
        var firstname = component.find("editfirstName").get("v.value");
        var lastname = component.find("editlastName").get("v.value");
        var phone = component.find("editphone").get("v.value");
        var email = component.find("editemail").get("v.value");
        var currconId = component.get("v.currentConId");
        
        var action = component.get("c.UpdateContact");
        action.setParams({
            "firstName" : firstname,
            "lastName" : lastname,
            "phone" : phone,
            "email" : email,
            "conId" : currconId
        });
        
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                helper.showUpdateSuccess(component,event);
                $A.get('e.force:refreshView').fire();
                component.set("v.CreateContactModel", false);
                component.set("v.editForm", false);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    deleteContact :  function(component, event, helper){
        debugger;
        var selConId = event.currentTarget.dataset.conid;
        // alert(selConId)
        var action = component.get("c.DeleteContact");
        action.setParams({
            "conId" : selConId
        });
        action.setCallback(this, function(response){
            var State = response.getState();
           helper.showDeleteWarning(component,event);
             $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
   
    
})