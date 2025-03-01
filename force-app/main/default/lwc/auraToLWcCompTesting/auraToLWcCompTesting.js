import { LightningElement,track,api } from 'lwc';

export default class AuraToLWcCompTesting extends LightningElement {
     DisplayText = false;
     textValue= 'LWC function Invoked through Aura Comp';
     @api LWCFunction(){
          this.DisplayText = true;
     }
}