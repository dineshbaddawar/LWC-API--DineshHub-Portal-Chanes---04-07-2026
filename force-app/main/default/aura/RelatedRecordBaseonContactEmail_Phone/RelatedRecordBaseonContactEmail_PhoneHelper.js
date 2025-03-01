({
    helperMethodOpportunity : function(component, event, helper) {
        component.set("v.oppColumns",[
            {label: 'Opportunity Name', fieldName: 'linkName', type: 'url',
             typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            {label:'Phone', fieldName: 'Phone__c', type:'phone'},
            {label:'Email', fieldName: 'Email__c', type:'email'},
        ]);
            debugger;
            var action = component.get("c.getOppDetails");
            var conEmailToPass = component.get("v.conEmail");
            var conPhoneToPass = component.get("v.conPhone");
            
            
            action.setParams({
            "conEmail" : conEmailToPass,
            "conPhone" : conPhoneToPass
            });
            //debugger;
            action.setCallback(this, function(response){
            var State = response.getState();
            
            
            var data = response.getReturnValue();
            console.log("Opp Detailed Data::",data);
            var oppIdToFindAccount = data[0].AccountId;
                      console.log("oppIdToFindAccount::",oppIdToFindAccount);
        component.set("v.AccountidforOpp",oppIdToFindAccount);
        data.forEach(function(record){
            record.linkName= '/'+record.Id;
        })
        component.set("v.OppRecordData",data);
        this.helperMethodAccount(component, event);
    });
    $A.enqueueAction(action);
},
 
 helperMethodAccount :function (component,event,helper) {
    component.set("v.accColumns",[
        {label: 'Account Name', fieldName: 'linkName', type: 'url',
         typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
        {label:'Phone', fieldName: 'Phone', type:'phone'},
        {label:'Email', fieldName: 'Email__c', type:'email'}
        
    ]);
    debugger;
    var action = component.get("c.getAccountDetails");
    var getAccId = component.get("v.AccountidforOpp");
    action.setParams({
        "oppAccountId" : getAccId
    });
    action.setCallback(this, function(response){
        var State = response.getState();
        debugger;
        var data = response.getReturnValue();
        console.log("Contact State data::",data);
        data.forEach(function(record){
            record.linkName='/'+record.Id;
        });
        component.set("v.AccRecordData",data);
    });
    $A.enqueueAction(action);
},
    
})