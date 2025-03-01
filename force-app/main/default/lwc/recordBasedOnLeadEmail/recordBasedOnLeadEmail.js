import { LightningElement,wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import Lead_OBJECT from '@salesforce/schema/Lead';
export default class RecordBasedOnLeadEmail extends LightningElement {
     defaultRecordTypeId
     @wire(getObjectInfo, { objectApiName: Lead_OBJECT})
    objectInfo({data,error}){
        if(data){
            console.log(data)
            this.defaultRecordTypeId = data.defaultRecordTypeId
        }
        if(error){
            console.error(error)
        }
    }
}