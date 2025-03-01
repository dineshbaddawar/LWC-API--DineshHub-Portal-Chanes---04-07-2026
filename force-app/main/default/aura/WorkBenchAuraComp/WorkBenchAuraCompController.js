({
    doInit : function(component, event, helper) {
        debugger;
    },
    receiveLWCData : function(component, event, helper){
         debugger;
        var dataToShow = event.getParam("dataToSend");
       // component.set("v.dataReceived", event.getParam("dataToSend"));
        if(dataToShow == 'SUCCESS'){
             component.set("v.ShowQueryResult", true);
             component.set("v.ShowQueryEditor", false);
        }
    },
})