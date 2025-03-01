import { LightningElement,wire,track } from 'lwc';
import contacts from '@salesforce/apex/UtilityClass.getContacts';

export default class ApexWireMethodsWithParams_1 extends LightningElement {
     strSearchText;
     detail;
     @wire (contacts, {strName:'$strSearchText'})
     conList;
     debugger;
     changeSearchText(event){
         this.strSearchText = event.target.value;
         this.detail = event.target.detail;
         console.log('The Search value-->'+this.strSearchText);
         console.log('The detail value-->'+this.detail);
     }
}