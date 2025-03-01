import { LightningElement,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import GetCloneData from '@salesforce/apex/ContactCloneController.GetCloneData';

export default class ContactCustomClone extends NavigationMixin (LightningElement) {
     @api recordId;

     @wire(GetCloneData, {conId: '$recordId'})
     getContactData({error, data}){
          if(data != null){
               console.log("The Data----------------",data);
               this.contactDataFromTheWireMethod(data);
          } else{
               console.log("The Error "+error);
          }
     }

     contactDataFromTheWireMethod(datToPass){
          const defaultData = encodeDefaultFieldValues(datToPass);
          this[NavigationMixin.Navigate]({
               type: "standard__objectPage",
               attributes: {
                    objectApiName: "Contact",
                    actionName: "new"
               },
               state: {
                    defaultFieldValues : defaultData
               }
          });
     }

}