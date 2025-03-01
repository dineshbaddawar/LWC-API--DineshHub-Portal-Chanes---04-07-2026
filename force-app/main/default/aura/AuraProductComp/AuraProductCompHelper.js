({
    helpersaveMethod : function(component,selectRecord){
        debugger;
         component.set("v.showSelectedProductList", selectRecord);
        component.set('v.showSelectedProducts', true); 
        component.set('v.showAllProducts', false); 
        component.set('v.showBackButton', true); 
    },
})