({
    handleSave : function(component, event, helper) {
        debugger;
        if(component.find("fileuploader").get("v.files").length > 0){
            helper.uploadHelper(component, event);
        }else{
            alert("Please Select a Valid File");
        }
    },
    handleFilesChange : function(component, event, helper){
        debugger;
        var fileName = 'No File Selected..';
        if(event.getSource().get("v.files").length > 0 ){
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    handleCancel : function(component, event, helper){
        debugger;
        $A.get("e.force:closeQuickAction").fire();
    },
})