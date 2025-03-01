import { LightningElement,wire } from 'lwc';
import getOpportunity from '@salesforce/apex/UtilityClass.getOpportunity';

export default class ApexWireMethodWithParams_2 extends LightningElement {
   
     searchText;
     @wire(getOpportunity, {SearchKey: '$searchText'})
     result;
     searchOpportunity(event){
          this.searchText = event.target.value;
     }
}