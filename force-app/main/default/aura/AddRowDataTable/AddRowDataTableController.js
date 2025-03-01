({
    addRow : function(component, event, helper) {
        // getting the account List from component
        var accountRecList = component.get("v.accountList")
        // Add new Account Record
        accountRecList.push({
            'sobjectType': 'Account',
            'Name': '',
            'Phone': '',
            'Fax': '',
            'Website': '',
        });
        component.set("v.accountList", accountRecList);
    },
    
    removeRecord : function(component, event, helper){
        alert("Remove Record");
        // getting the accountList
        var accountRecList = component.get("v.accountList");
        // getting the target object
        var selectedItem = event.currentTarget;
        // getting the selected item index
        var index = selectedItem.dataset.record;
        // remove single record from account List
        accountRecList.splice(index, 1);
        // set modified account list
        component.set("v.accountList", accountRecList);
    },
    
    saveAccounts : function(component, event, helper){
        alert('SaveMethod Called');
        if(helper.validateAccountRecords(component, event)){
            // Calling Apex method & passing account List as parameters
            var action = component.get("c.getAccountRecords");
            action.setParams({
                "accList" : component.get("v.accountList")
            });
            action.setCallback(this, function(response){
                // get state of response
                var state = response.getState();
                if(state == 'SUCCESS'){
                    // set empty account List
                    component.set("v.accountList", []);
                    alert('Account Record saved Successfully'); 
                    
                    
                    
                }
            });
            $A.enqueueAction(action);
        }
    }
})