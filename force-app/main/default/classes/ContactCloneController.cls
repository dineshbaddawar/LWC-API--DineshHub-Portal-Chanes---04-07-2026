public class ContactCloneController {

    Static final String SELECT_CLAUSE = 'SELECT ';
    Static final String WHERE_CLAUSE = 'WHERE ';
    
    @AuraEnabled(cacheable=true)
    Public Static Contact GetCloneData(String conId){
        List<Schema.FieldSetMember> FieldSetFromContact = SobjectType.Contact.FieldSets.ContactFieldSet.getFields();
        List<String> FieldListToAddFieldSet = new List<String>();
        try {
            for(FieldSetMember FieldSet : FieldSetFromContact){
                FieldListToAddFieldSet.add(String.valueOf(FieldSet.sobjectfield));
            }
            String query = SELECT_CLAUSE + String.join(FieldListToAddFieldSet, ', ');
            query += ' FROM Contact '+WHERE_CLAUSE + 'Id =:conId';
            System.debug('The Query---------- '+query);
            return Database.query(query);
        }catch(Exception e){
            System.debug('The Error : '+e.getMessage());
            System.debug('The Error Line '+e.getLineNumber());
        }
        return null;
    }
    
    /*
     LWC :

JS:

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


XML:

<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>52.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__RecordAction</target>
        <target>lightning__RecordPage</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightning__RecordAction">
            <actionType>ScreenAction</actionType>
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>

     */
}