// Passing Record Id from LWC to Aura using Custom Event.
// Aura Comp Name : HostLwc
import { LightningElement } from 'lwc';
export default class LightningInputFieldInLwc extends LightningElement {
 handleChange(event) {
     debugger;
    const value = event.target.value;
    const valueChangeEvent = new CustomEvent("valuechange", {
      detail: { value }
    });
    // Fire the custom event
    this.dispatchEvent(valueChangeEvent);
  }
}