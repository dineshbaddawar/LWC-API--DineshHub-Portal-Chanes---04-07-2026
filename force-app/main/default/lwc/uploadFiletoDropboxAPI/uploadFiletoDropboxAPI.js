import { LightningElement } from 'lwc';
export default class UploadFiletoDropboxAPI extends LightningElement {
connectedCallback() {
          debugger;
          setTimeout(() => {
               this.callApexMethod();
          }, 300);
     }
}