({
    doInit: function(component, event, helper) {
        debugger;
        var auth_code = component.get("v.authcode");
        var recordId=component.get("v.recordId");
        var SobjectrecId = component.get("v.SobjectrecId");
        if(recordId.startsWith("00Q")){
            component.set("v.objectAPIName","Lead");
        }else if(recordId.startsWith("006")){
            component.set("v.objectAPIName","Opportunity");
        }
    },
	HandleChange : function(component, event, helper) {
		debugger;
       // var value=event.currentTarget.value;
       var value = event.getSource().get("v.value");
        component.set("v.SelectedWorkshop",value);
	},
    handleCancel:function(component, event, helper) {
        debugger;
        $A.get("e.force:closeQuickAction").fire(); 
    },
    handleClickNext:function(component, event, helper) {
        debugger;
        var value= component.get("v.SelectedWorkshop");
        if(value=='Online Workshop'){
           component.set("v.ShowTeamsMeetingCmp",true);
            component.set("v.ShowToCreateVisit",false);
            component.set("v.firstScreen",false);
        }else if(value=='Site Workshop'){
            component.set("v.ShowToCreateVisit",true);
            component.set("v.ShowTeamsMeetingCmp",false);
            component.set("v.firstScreen",false);
        }
    },
    handlePrevious:function(component, event, helper) {
        debugger;
        component.set("v.firstScreen",true);
        component.set("v.ShowToCreateVisit",false);
        component.set("v.ShowTeamsMeetingCmp",false);
    },
    HandleDateChange:function(component, event, helper) {
        debugger;
        var value=event.currentTarget.value;
        const date = new Date();
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if(value<today){
            alert('Visit Date should Not Less Than Current Date');
            component.set("v.workshopDate",'');
        }
        
    },
    HandleAttendesChange:function(component, event, helper) {
        debugger;
        var attendes=component.get("v.attendes");  
    },
    handleClickSave:function(component, event, helper) {
        debugger;
        var VisitList=[];
        
        var attendes=component.get("v.attendes");
        var city=component.get("v.city");
        var street=component.get("v.street");
        var country=component.get("v.country");
        var state=component.get("v.province");
        var postalcode=component.get("v.postalCode");
        var workshopDate=component.get("v.workshopDate");
        var Description=component.get("v.Description");
        var RecordId=component.get("v.recordId");
        
        if(attendes==null || attendes==undefined){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'ERROR',
                message: 'Attendes are Mandatory',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }
        
        if(attendes.includes(';') || attendes.includes('+') || attendes.includes('&') || attendes.includes(':') || 
           attendes.includes('/') || attendes.includes('!') || attendes.includes('?') || 
           attendes.includes('-') || attendes.includes('*')){
              var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'ERROR',
                message: 'We Only Accept comma For Attendes Separation',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }
        var attendesArray=attendes.split(',');
        console.log('attendesArray--'+JSON.stringify(attendesArray));
        
        for(let i=0;i<attendesArray.length;i++){
            let obj={Attendees__c:'',City__c:'',Country__c:'',State__c:'',Street__c:'',Postal_Code__c:'',Workshop_Date__c:'',Description__c:'',Opportunity__c:''};
            obj.Attendees__c=attendesArray[i];
            
            RecordId!=null || RecordId!=undefined ? obj.Opportunity__c=RecordId : obj.Opportunity__c=null
            city!=null || city!=undefined ? obj.City__c=city : obj.City__c=null
            country!=null || country!=undefined ? obj.Country__c=country : obj.Country__c=null
            state!=null || state!=undefined ? obj.State__c=state : obj.State__c=null
            street!=null || street!=undefined ? obj.Street__c=street : obj.Street__c=null
            postalcode!=null || postalcode!=undefined ? obj.Postal_Code__c=postalcode : obj.Postal_Code__c=null
            workshopDate!=null || workshopDate!=undefined ? obj.Workshop_Date__c=workshopDate : obj.Workshop_Date__c=null
            Description!=null || Description!=undefined ? obj.Description__c=Description: obj.Description__c=null
            
             VisitList.push(obj);
            
        }
        console.log('VisitList---',JSON.stringify(VisitList));
        
        var action = component.get("c.CreateVisit");
        action.setParams({
            "VisitList": VisitList 
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state == "SUCCESS") {
                {
                 $A.get("e.force:closeQuickAction").fire();    
                }
            }else{
               $A.get("e.force:closeQuickAction").fire();  
            }
        }));
        $A.enqueueAction(action);
          
    },
    parentComponentEvent:function(component, event, helper) {
        debugger;
        component.set("v.firstScreen",true);
        component.set("v.ShowToCreateVisit",false);
        component.set("v.ShowTeamsMeetingCmp",false);
    }
})