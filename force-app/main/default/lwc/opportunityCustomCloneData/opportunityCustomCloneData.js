import { LightningElement,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import GetCloneDataOpp from '@salesforce/apex/OpportunityCloneController.GetCloneDataOpp';

export default class OpportunityCustomCloneData extends NavigationMixin (LightningElement) {
     @api recordId;
     @wire(GetCloneDataOpp, {oppId: '$recordId'})
     getOppData({error, data}){
          if(data !=null){
               console.log("data=============== ", data);
               this.datfromDataOpp(data);
          }else {
               console.log('The Error  '+error);
          }
     }
datfromDataOpp(dataOpp){
     const defauldataValues = encodeDefaultFieldValues(dataOpp);
     this[NavigationMixin.Navigate]({
          type: "standard__objectPage",
          attributes: {
               objectApiName: "Opportunity",
               actionName: "new"
          },
          state: {
               defaultFieldValues : defauldataValues
          }
     });
}

}