import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import sendPaymentLink from '@salesforce/apex/RazorpayPaymentLWCController.initatePayment';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RazorpayPayment extends LightningElement {
    @api recordId;

    connectedCallback(){
        setTimeout(() => {
            this.initiatePayment();
        }, 300);
    }

    initiatePayment(){
        console.log('Payment initiated on -----',this.recordId);
        sendPaymentLink({recordId:this.recordId}).then(response=>{
            if(response=='Success'){
                this.showNotification('Success','Payment link sent succesfully!','success');
                this.closeAction();
            }else{
                this.showNotification('Failed',response,'error');
                this.closeAction();
            }
        }).catch(error=>{
            this.showNotification('Failed',error,'error');
            this.closeAction();
        })
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }


    showNotification(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}