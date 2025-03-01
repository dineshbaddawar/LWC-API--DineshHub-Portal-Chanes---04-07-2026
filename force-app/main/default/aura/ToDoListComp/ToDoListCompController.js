({
    doInit: function (component, event, helper) {
        debugger;
        var now = new Date();
        var date = now.getDate();
        var month = now.getMonth() + 1;
        var fullYear = now.getFullYear();
        var today = fullYear + '-' + month + '-' + date;
        component.set("v.today", today);
        
       
        helper.getData(component,event,helper);
    },
    
    toggleForm : function(component,event,helper){
        debugger;
        
        var evtSource = event.getSource();
        if(evtSource.get("v.iconName") === 'utility:down'){
            evtSource.set("v.iconName" , 'utility:right' );
        }else{
            evtSource.set("v.iconName" , 'utility:down' );
        }
        
        $A.util.toggleClass(component.find("formDiv"),'slds-hide');
    },
    
    saveTodo : function(component,event,helper){
        debugger;
        
        var accId = component.get( "v.recordId" );
        var objToDo = component.get("v.objToDo");
        
        var action = component.get("c.saveToDoRecord");
        
        action.setParams({
            'toDoRecord' : objToDo,
            'accId' : accId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var toastRef = $A.get("e.force:showToast");
                if(response.getReturnValue() == null){
                    toastRef.setParams({
                        "type" : "Success",
                        "title" : "Success",
                        "message" : "New Task is Created.",
                        "mode" : "dismissible"
                    });
                }
                else{
                    toastRef.setParams({
                        "type" : "Error",
                        "title" : "Error",
                        "message" : response.getReturnValue(),
                        "mode" : "sticky"
                    }); 
                }
                toastRef.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                
                $A.get("e.force:refreshView").fire();
            }
            else{
                
                console.log('Error during saving '+state);
            }
        });
        $A.enqueueAction(action);          
        
    },
    
    setMaxValueOfReminderDate : function(component, event, helper){
        
        debugger;
        var dueDate = event.getSource().get("v.value");
        
        component.find("reminderDate").set("v.value",'');
        
        if(dueDate != null && dueDate != ''){
            
            component.find("reminderDate").set("v.disabled",false);
            
            component.find("reminderDate").set("v.max",dueDate);
        }
        else{
            component.find("reminderDate").set("v.disabled",true);
        }        
    },
    
})