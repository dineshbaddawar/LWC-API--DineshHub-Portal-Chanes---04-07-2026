import { LightningElement, track, api, wire } from 'lwc';
// import updateQuoteLineItems  from '@salesforce/apex/QuoteScreenController.updateQuoteLineItems';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from "lightning/actions";
// import BaseURLQuote from '@salesforce/label/c.BaseURLQuote';
export default class UpdateQuoteLineItems extends LightningElement {
@api selectedRows = [];
@track oppLineItems = [];
@api recordId;
@track isEditOliOpen= true;
@track isLoading = false;

        connectedCallback() { 
            debugger;
            console.log('selectedRows...',JSON.stringify(this.selectedRows));
            for(let i =0;i<this.selectedRows.length;i++){
                var temp = {
                    "Id":this.selectedRows[i].Id,
                    "quoteId": this.recordId,
                    "ProductName":this.selectedRows[i].ProductName,
                    "Family":this.selectedRows[i].Family,
                    "quantity" : this.selectedRows[i].Quantity, 
                    "listPrice" : this.selectedRows[i].ListPrice,
                    "salesPrice": this.selectedRows[i].UnitPrice,                                       
                    "totalValue" : this.selectedRows[i].TotalPrice,
                }
                console.log('data === >'+temp);
                this.oppLineItems.push(temp);
        }
    }

    handleInputChange(event){
    debugger;
    // Update the oppLineItems when the input value changes
            var oppId = event.target.dataset.id;
            const field = event.target.dataset.field;
            const value = event.target.value;
            this.oppLineItems = this.oppLineItems.map(item => {
            if (item.Id === oppId) {
                return this.calculateFields({ ...item, [field]: value });
            }
            return item;
       });
    }
        calculateFields(item) {
        debugger
            const actualSalesPrice = item.salesPrice;
            // Calculate Total Value
            item.totalValue = item.quantity * actualSalesPrice || 0;
            return item;
        }
}