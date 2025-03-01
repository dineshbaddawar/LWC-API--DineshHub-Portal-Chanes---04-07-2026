import { LightningElement,api } from 'lwc';

export default class RecordFormDynamicContact extends LightningElement {

     @api recordId;
     @api objectApiName;
     fields = ['Name','Phone','Email', 'Title'];
}