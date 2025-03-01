import { LightningElement,track } from 'lwc';
export default class Componenteventparentcomp extends LightningElement {
    @track childMessage;
handleChildClick(event) {
    debugger;
        console.log('Received event from child:', event.detail);
        // Handle child click event
        const eventData = event.detail;
        this.childMessage = eventData;
        // Do something with eventData
    }
    handleClickParent(){
        debugger;
         this.childMessage = null;
    }
}