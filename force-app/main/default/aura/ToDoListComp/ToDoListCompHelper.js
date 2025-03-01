({
    getData : function(component,event,helper){
        debugger;
         component.set("v.todoColumnsDataTable",[
            {
                label:'Description',
                fieldName : 'linkToRecord',
                type:'url',
                typeAttributes:{label:{fieldName:'Description__c'},target:'_blank'}
            },
            {
                label :'Due Date',
                fieldName:'Due_Date__c',
                type:'date',
                typeAttributes:{day:'2-digit',month:'long',year:'2-digit'}
            },
           //  {label: 'ID', fieldName: 'Id', type: 'text'},
            {
                label:'Reminder Date',
                fieldName:'Reminder_Date__c',
                type:'date',
                typeAttributes:{day:'2-digit',month:'long',year:'2-digit'}
            }
        ]);
        
        
        var action = component.get("c.loadData");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var todoList = response.getReturnValue();
                for(var i=0; i < todoList.length;i++){
                    // to make upper Case value
                   todoList[i].Description__c = todoList[i].Description__c;
                    todoList[i].linkToRecord = '/'+todoList[i].Id;
                    
                }
                component.set("v.objToDoList",todoList);
                console.log("todoList :::",todoList)
            }
            else{
               
                console.log('Error occured while init of data '+state);
            }
        });
        $A.enqueueAction(action);
    },
    
    validateData: function (component, event, helper) {
        debugger;
        var isValid = component.find("todoForm").reduce(function(validSoFar,inputComp){
            
            inputComp.showHelpMessageIfInvalid();
            return validSoFar && inputComp.get("v.validity").valid;
        },true);
        return isValid;
    }
})