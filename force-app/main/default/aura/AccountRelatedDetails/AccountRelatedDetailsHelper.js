({
    InsertMethod : function(component, event, deleteRecordsIds) {
        debugger;
        var conLIst = [];
        
        
        if(deleteRecordsIds.conList.length > 0){
            component.set("v.isModalOpenContact", true);
            for(var i=0;i<deleteRecordsIds.conList.length;i++){
                conLIst.push(deleteRecordsIds.conList[i]);
            }
            component.set("v.contactLiist",conLIst);
        }else{
            component.set("v.isModalOpenContact", false)
                alert("No record Found !")
        }
    },
    
    showOpportunity : function(component, event, deleteRecordsIds) {
        var oppList = [];
          if(deleteRecordsIds.oppList.length > 0){
            component.set("v.isModalOpenOpportunity", true);
             for(var i=0;i<deleteRecordsIds.oppList.length;i++){
                oppList.push(deleteRecordsIds.oppList[i]);
            }
            component.set("v.opportunityList",oppList);
        }else{
            component.set("v.isModalOpenOpportunity", false)
                alert("No record Found !")
        }
    },
    
    showCase : function(component, event, deleteRecordsIds) {
         var casedataList = [];
          if(deleteRecordsIds.caseList.length > 0){
            component.set("v.isModalOpenCase", true);
             for(var i=0;i<deleteRecordsIds.caseList.length;i++){
                casedataList.push(deleteRecordsIds.caseList[i]);
            }
            component.set("v.caseList",casedataList);
        }else{
            component.set("v.isModalOpenCase", false)
                alert("No record Found !")
        }
    }
})