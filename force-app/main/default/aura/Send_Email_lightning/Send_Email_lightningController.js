({
	doInit : function(component, event, helper) {
        debugger;
		var recordId = component.get('v.recordId');
	   // var recordId = '0015i00000P19ISAAZ';
        var ObjectName = "Contact";
        var FieldNameGender= "Gender__c";
          helper.helperMethod(component, event);
        var action = component.get("c.getPickListValuesMethod");
        action.setParams({
            "ObjectApi_name" : ObjectName,
            "Field_Name" : FieldNameGender
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.pickListValuesGender", result);
            }
        });
        $A.enqueueAction(action);
	},
    
    geSelectedPicValue : function(component, event, helper) {
         debugger;
        var SelGender = component.find("conGener").get("v.value");
        var SelConType =  component.find("conType").get("v.value");
    },
    
    sendEmailToContact : function(component, event, helper) {
        debugger;
        var action = component.get("c.GetContactBySendAccountId");
         var SelGender = component.find("conGener").get("v.value");
        var SelConType =  component.find("conType").get("v.value");
        var recordId = component.get('v.recordId');
        action.setParams({
            "accountId" : recordId,
            "gender" : SelGender,
            "conType" : SelConType
        });
        action.setCallback(this, function(response){
            var State = response.getState();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            helper.showSuccess(component, event);
        });
         $A.enqueueAction(action);
    },
    
    closeModel : function(component, event, helper) {
          var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})