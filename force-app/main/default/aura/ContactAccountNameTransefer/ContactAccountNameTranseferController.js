({
    onPageReferenceChange : function(component, event, helper) {
        debugger;
        var myPageRef = component.get("v.pageReference");
        var label = $A.get("$Label.c.listViewContactId");
        var Contacts = myPageRef.state.c__listofContacts;
        helper.GetAccountNameGroup(component,event);
        if(Contacts.length < 0 || Contacts.length == ""){
            helper.showWarning(component, event);
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewContactId" : label,
                "listViewName" : "All Contacts",
                "scope" : "Contact"
            });
            navEvent.fire();
        }else{
            var ContactArr = Contacts.split(',');
            component.set("v.conList", ContactArr);
            component.set("v.isModelOpen", true);
        }
    },
    closeModel : function(component, event, helper){
         debugger;
        component.set("v.isModelOpen", false);  
        var ContactListView = component.get("v.AllContactListView");
        component.set("v.isModelOpen", false);
        var navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            "listViewId": ContactListView.Id,
            "listViewName": ContactListView.Name,
            "scope": "Contact"
        });
        navEvent.fire();
    },
    
    submitDetails: function (component, event, helper) {
         debugger;
        var selectedAssignGroupForJs = component.get("v.SelectedAssignGroup");
        var contactList = component.get("v.conList");
        var conSize = contactList.length;
        if(contactList.length == 1 && contactList.length[0] == ""){
            var ContactListView = component.get("v.AllContactListView");
            component.set("v.isModelOpen", false);
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": ContactListView.Id,
                "listViewName": ContactListView.Name,
                "scope": "Contact"
            });
            navEvent.fire();
        }else{
            var action = component.get("c.ChangeContactAccountName");
            action.setParams({
                "ContactListId" : contactList,
                "SelctedAccountId" : selectedAssignGroupForJs
            });
            action.setCallback(this, function(response){
                var State = response.getState();
                if(State === "SUCCESS"){
                    var data = response.getReturnValue();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'SUCCESS',
                        message: 'Account Name Changed Successfully !',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    var ContactListView = component.get("v.AllContactListView");
                    component.set("v.isModelOpen", false);
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewId": ContactListView.Id,
                        "listViewName": ContactListView.Name,
                        "scope": "Contact"
                    });
                    navEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    }
})