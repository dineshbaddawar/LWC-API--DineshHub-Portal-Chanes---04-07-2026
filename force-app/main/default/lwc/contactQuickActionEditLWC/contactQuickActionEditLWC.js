import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class ContactQuickActionEditLWC extends LightningElement {
@api recordId;
@api objectApiName;
debugger;
     contactUpdate(e) {
          this.dispatchEvent(new CloseActionScreenEvent());
          this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Success',
                  message: 'Contact Record Updated!',
                  variant: 'success'
              })
          );
}
}