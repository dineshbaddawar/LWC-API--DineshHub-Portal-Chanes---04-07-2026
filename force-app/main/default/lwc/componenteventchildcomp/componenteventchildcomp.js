import { LightningElement } from 'lwc';
export default class Componenteventchildcomp extends LightningElement {
handleClick() {
    debugger;
        const eventData = 'Data to send to parent';
        this.dispatchEvent(new CustomEvent('childclick', { detail: eventData }));
    }
}