import { LightningElement,api } from 'lwc';
export default class Customspinner extends LightningElement {
  @api spinnerText = 'Fetching Folders , please wait...';
  @api secondText = 'Uploading to Google Drive....';
    connectedCallback() {
        debugger;
        setTimeout(() => {
            this.spinnerText = this.secondText;
        }, 3000); 
    }
}