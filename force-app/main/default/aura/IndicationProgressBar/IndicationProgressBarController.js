({
    handleNext : function(component,event,helper){
        var getselectedStep = component.get("v.selectedStep");
        if(getselectedStep == "LoanInfo"){
            component.set("v.selectedStep", "BasicInfo");
        }
        else if(getselectedStep == "BasicInfo"){
            component.set("v.selectedStep", "ResidenceInfo");
        }
            else if(getselectedStep == "ResidenceInfo"){
                component.set("v.selectedStep", "IncomeInfo");
            }
    },
    
    handlePrev : function(component,event,helper){
        alert("Inside handlePrev Method");
        var getselectedStep = component.get("v.selectedStep");
        if(getselectedStep == "BasicInfo"){
            component.set("v.selectedStep", "LoanInfo");
        }
        else if(getselectedStep == "ResidenceInfo"){
            component.set("v.selectedStep", "BasicInfo");
        }
            else if(getselectedStep == "IncomeInfo"){
                component.set("v.selectedStep", "ResidenceInfo");
            }
    },
    
    handleFinish : function(component,event,helper){
        alert('Finished...');
        component.set("v.selectedStep", "LoanInfo");
    },
    
    selectStep1 : function(component,event,helper){
        component.set("v.selectedStep", "LoanInfo");
    },
    selectStep2 : function(component,event,helper){
        component.set("v.selectedStep", "BasicInfo");
    },
    selectStep3 : function(component,event,helper){
        component.set("v.selectedStep", "ResidenceInfo");
    },
    selectStep4 : function(component,event,helper){
        component.set("v.selectedStep", "IncomeInfo");
    },
});