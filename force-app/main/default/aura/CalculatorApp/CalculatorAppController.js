({
    addFunction : function(component, event, helper) {
        var num1 = component.find("num1").get("v.value");
        var num2 = component.find("num2").get("v.value");
        
        var Addition = Number(num1)+Number(num2);
        
        component.set("v.sum", Addition);
        
    },
    
    mulFunction : function(component, event, helper){
        var num1 = component.find("num1").get("v.value");
        var num2 = component.find("num2").get("v.value");
        var Multiplication = num1 * num2;
        component.set("v.mul", Multiplication);
    },
    
    divFunction : function(component, event, helper){
        var num1 = component.find("num1").get("v.value");
        var num2 = component.find("num2").get("v.value");
        var Division = num1 / num2;
        component.set("v.div", Division);
    },
    
    subFunction : function(component, event, helper){
        var num1 = component.find("num1").get("v.value");
        var num2 = component.find("num2").get("v.value");
        var Division = num1 - num2;
        component.set("v.sub", Division);
    },
    
})