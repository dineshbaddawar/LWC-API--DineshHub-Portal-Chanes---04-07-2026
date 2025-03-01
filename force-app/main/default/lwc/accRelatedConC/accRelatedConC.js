import { LightningElement,wire,api } from 'lwc';
import fetchAcc from '@salesforce/apex/UtilityClass.fetchAcc';
export default class AccRelatedConC extends LightningElement {
     data1 = [];
     wiredActivities;
     records = '';
     error;
     @api recordId;
     @wire(fetchAcc,{
         RecId:'$recordId'
     })
     wiredclass({
         data, error
         
     }){
     if(data){
         let dataEditing = JSON.parse(JSON.stringify(data));
         console.log(JSON.stringify(dataEditing));
         this.records = dataEditing.length;
         this.data1 = dataEditing;
         
     }else if(error){
         this.error = error;
     }
     
 }
}