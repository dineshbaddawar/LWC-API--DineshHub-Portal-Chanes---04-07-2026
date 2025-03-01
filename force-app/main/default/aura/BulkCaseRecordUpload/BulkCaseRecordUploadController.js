({
    onchange: function(component, event, helper) {
        debugger;
        event.stopPropagation();
        event.preventDefault();
        debugger;
        var fileName = 'No File Selected.';
        if (event.getSource().get("v.files").length > 0) { 
            fileName = event.getSource().get("v.files")[0];//['name'];
        }
        var uploadfileName = fileName['name'];
        const parts = uploadfileName.split('.');
        const fileExtension = parts[parts.length - 1];
        if(fileExtension == 'xlsx' || fileExtension == 'xls'){
            debugger;
            var lwcComponent = component.find("lwcComponent");
            lwcComponent.handleFileUpload(event);
        }
        component.set("v.FileNameRecord", fileName['name']);
        helper.readFile(component,helper,fileName);
    },
    processFileContent : function(component,event,helper){
        debugger;
        helper.saveRecords(component,event);
    },
    cancel : function(component,event,helper){
        component.set("v.showFirstScreen",true);
        component.set("v.showMain",false);
    },
    
    handleClickOutOfStock : function(component,event,helper){
        debugger;
        var tempName = 'OutOfStock';
        component.set("v.tempNameToDownload",tempName); 
        component.set("v.showScondScreen",true);
        component.set("v.showFirstScreen",false);
    },
    handleClickPincodeNotservice : function(component,event,helper){
        debugger;
        var tempName = 'PinCodeService';
        component.set("v.tempNameToDownload",tempName);
        component.set("v.showScondScreen",true);
        component.set("v.showFirstScreen",false);
    },
    handleClickCourierDeliveryIssue : function(component,event,helper){
        debugger;
        var tempName = 'DeliveryIssue';
        component.set("v.tempNameToDownload",tempName);
        component.set("v.showScondScreen",true);
        component.set("v.showFirstScreen",false);
    },
    handleClickLostInTransit : function(component,event,helper){
        debugger;
        var tempName = 'LostInTransit';
        component.set("v.tempNameToDownload",tempName);
        component.set("v.showScondScreen",true);
        component.set("v.showFirstScreen",false);
    },
    handleClickDelayInDelivery : function(component,event,helper){
        debugger;
        var tempName = 'DeleayInDelivery';
        component.set("v.tempNameToDownload",tempName);
        component.set("v.showScondScreen",true);
        component.set("v.showFirstScreen",false);
    },
    handleClickRToOrders : function(component,event,helper){
        debugger;
        var tempName = 'RToOrders';
        component.set("v.tempNameToDownload",tempName);
        component.set("v.showScondScreen",true);
        component.set("v.showFirstScreen",false);
    },
    getValueFromLwc : function(component, event, helper) {
        debugger;
        var value = event.getParam('value');
        if(value == 'HideCSV'){
            component.set("v.ShowCSV",false);
        }
        
    }
})