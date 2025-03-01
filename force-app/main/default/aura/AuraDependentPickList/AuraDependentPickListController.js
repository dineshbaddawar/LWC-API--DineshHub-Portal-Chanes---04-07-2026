({
    doInit : function(component, event, helper) {
        //	alert("Hello World")
        debugger;
        var parentPickValue = [
            {text: "India", value:"India"},
            {text: "England", value:"England"}
        ];
        
        var depPick = {
            "India" : [
                {text: "Mumbai", value:"Mumbai"},
                {text: "Pune", value:"Pune"}
            ],
            "England" : [
                {text: "London", value:"London"},
                {text: "Oval", value:"Oval"}
            ]
        }; 
        
        component.set("v.parentOptionList", parentPickValue); 
         component.set("v.dependentPickList", depPick);
    },
    
    pickChange : function(component, event, helper) {
       debugger;
        var getParentValue = component.find("parentpick").get("v.value");
       //  alert("Dependent Value is :",getParentValue);
        component.set("v.dependentOptionList", component.get("v.dependentPickList")[getParentValue]);
    },
})