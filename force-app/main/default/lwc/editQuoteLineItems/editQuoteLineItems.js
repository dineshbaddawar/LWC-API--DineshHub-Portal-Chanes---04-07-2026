import { LightningElement, api, track, wire } from 'lwc';
import getQLIBasedOnQuoteId from "@salesforce/apex/LWCUtilityHelper.getQLIBasedOnQuoteId";
import { CloseActionScreenEvent } from "lightning/actions";
const columns = [
    { label: 'Product Name', fieldName: 'ProductName',
    cellAttributes: {
        alignment: 'center'
    },},

    { label: 'Quantity', fieldName: 'Quantity', type: 'number',
    cellAttributes: {
        alignment: 'center'
    },},

    { label: 'List Price', fieldName: 'ListPrice', type: 'number',
    cellAttributes: {
        alignment: 'center'
    },},

    { label: 'Sales Price', fieldName: 'UnitPrice', type: 'currency',
    cellAttributes: {
        alignment: 'center'
    },},

    { label: 'Total Price', fieldName: 'TotalPrice', type: 'currency',
    cellAttributes: {
        alignment: 'center'
    },},
    
];
export default class EditQuoteLineItems extends LightningElement {
@api recordId;
 @track columns=columns;
 @track oppLineItems;
 @track error;
 @track selectedRows = [];
 @track isLineItemModalOpen =true;
 @track isShowSelectedItems=false;
 @track searchTerm ='';
 @track items = [];

  @wire(getQLIBasedOnQuoteId,{quoteId : "$recordId"})
    wiredOppLineItems({error, data}){
        debugger;
        if(data){
            let tempList = [];
            for(var i=0;i<data.length;i++){
                let tempObj = {
                    Id:data[i].Id,
                    ProductName:data[i].Product2.Name,
                    Family:data[i].Product2.Family,
                    Quantity:data[i].Quantity,
                    ListPrice:data[i].ListPrice,
                    UnitPrice:data[i].UnitPrice,
                    TotalPrice:data[i].TotalPrice
                }
                tempList.push(tempObj);
            }
            this.oppLineItems = tempList;
            this.items = this.oppLineItems;
            this.error=undefined;
        }else if(error){
            this.oppLineItems = undefined;
            this.error=error;
        }
    }

     handleRowSelection(event) {
        debugger;
        this.selectedRows = event.detail.selectedRows;
        console.log('Selected Rows Id === > :', JSON.stringify(this.selectedRows[0].Id));
    }

    handleNext(){
         debugger;
         this.isLineItemModalOpen = false;
         this.isShowSelectedItems = true;
     }
    
    handleCancel(){
        debugger;
        this.closeModal();
    }

    modalCloseHandler(){
        this.closeModal();
    }

    closeModal() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}