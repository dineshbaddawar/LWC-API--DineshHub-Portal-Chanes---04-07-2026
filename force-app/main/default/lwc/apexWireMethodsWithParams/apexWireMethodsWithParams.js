import { LightningElement,wire,track } from 'lwc';
import accounts from '@salesforce/apex/UtilityClass.getAccounts';

export default class ApexWireMethodsWithParams extends LightningElement {
     strSearchText;
     @wire (accounts, {strName:'$strSearchText'})
     lstAccount;
     changeSearchText(event){
         this.strSearchText = event.target.value;
     }

    
}