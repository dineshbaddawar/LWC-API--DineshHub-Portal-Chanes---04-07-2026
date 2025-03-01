import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class CustomLeadUpdate extends LightningElement {
     debugger;
     @api recordId;
     @api objectApiName;

     handleSuccess(e){
         // alert("Method Called")
          console.log("Method Called")
          this.dispatchEvent(new CloseActionScreenEvent());
          this.dispatchEvent(
               new ShowToastEvent({
                    title: 'SUCCESS',
                    message: 'Record Updated Successfully !',
                    variant: 'success'
               })
          );
     }
}