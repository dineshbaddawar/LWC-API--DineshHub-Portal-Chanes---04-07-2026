({
    helperMethodContact :function (component,event,helper) {
            component.set("v.mycontactcolumns",[
            {label: 'Contact Name', fieldName: 'linkName', type: 'url',
             typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
             {label:'Phone', fieldName: 'Phone', type:'text'},
            {label:'Email', fieldName: 'Email', type:'email'}
        ]);
        var action = component.get("c.getContactsByEmailData");
        var conEmail = component.get("v.leadEmailRec");
        console.log("conEmail ::::",conEmail);
        var conPhone = component.get("v.leadPhoneRec");
        console.log("conPhone ::::",conPhone);
        action.setParams({
            "emailId" : conEmail,
            "conPhone" : conPhone
        })
        action.setCallback(this, function(response){
            var State = response.getState();
            console.log("State Contact :::",State);
            if(State === 'SUCCESS'){
                var data = response.getReturnValue();
                data.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                console.log("Contact Data ::::con",data)
                component.set("v.ContactRecordData",data);
                this.helperMethodOpportunity(component, event);
            }
        });
        $A.enqueueAction(action);
    },
    
    helperMethodOpportunity :function (component,event,helper) {
          component.set("v.myopportunitycolumns",[
            {label: 'Opportunity Name', fieldName: 'linkName', type: 'url',
             typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
             {label:'Phone', fieldName: 'Phone__c', type:'text'},
            {label:'Email', fieldName: 'Email__c', type:'email'}
        ]);
        var action = component.get("c.getOpportunityBEmailData");
        var oppEmail = component.get("v.leadEmailRec");
        var oppPhone = component.get("v.leadPhoneRec");
        action.setParams({
            "emailId" : oppEmail,
            "oppPhone" : oppPhone
        })
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                var data = response.getReturnValue();
                data.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set("v.OpportunityRecordData", data);
                this.helperMethodAccount(component, event);
            }
        });
         $A.enqueueAction(action);
    },
    
    helperMethodAccount :function (component,event,helper) {
         component.set("v.myaccountcolumns",[
            {label: 'Account Name', fieldName: 'linkName', type: 'url',
             typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
             {label:'Phone', fieldName: 'Phone', type:'text'},
            {label:'Email', fieldName: 'Email__c', type:'email'}
        ]);
        var action = component.get("c.getAccountByEmailData");
        var accEmail = component.get("v.leadEmailRec");
        var accPhone = component.get("v.leadPhoneRec");
        action.setParams({
            "emailId" : accEmail,
            "accPhone" : accPhone
        })
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                var data = response.getReturnValue();
                data.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set("v.AccountRecordData", data);
            }
        });
        $A.enqueueAction(action);
    },         
})