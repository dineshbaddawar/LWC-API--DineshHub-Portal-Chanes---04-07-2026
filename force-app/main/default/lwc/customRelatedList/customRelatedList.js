/**
 * @author [Dinesh Baddawar]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2024-07-01 16:09:01
 * @modify date 2024-07-02 23:57:48
 * @desc [description]
 */

import { LightningElement, api, track } from 'lwc';
import fetchRecords from '@salesforce/apex/LWCUtilityHelper.fetchRecords';
import { NavigationMixin } from 'lightning/navigation'; 
const actions = [{ label: 'View', name: 'show_details' }];
const columns = [
     { label: 'Product Code', fieldName: 'RecordUrl', type: 'url', sortable: true, cellAttributes: { alignment: 'left' }, typeAttributes: { label: { fieldName: 'Item_Number__c' }, target: '_blank' } },
     { label: 'Description', fieldName: 'Description', type: 'text', sortable: true, cellAttributes: { alignment: 'left' } },
     { label: 'Description 2', fieldName: 'Description_2__c', type: 'text', sortable: true, cellAttributes: { alignment: 'left' } },
     { label: 'Quantity', fieldName: 'Quantity', type: 'number', sortable: true, cellAttributes: { alignment: 'left' } },
     { label: 'Sales Price', fieldName: 'UnitPrice', type: 'currency', sortable: true, cellAttributes: { alignment: 'left' } },
     { label: 'Note', fieldName: 'Note__c', type: 'text', sortable: true, cellAttributes: { alignment: 'left' } },
     { label: 'Subtotal', fieldName: 'Subtotal', type: 'currency', sortable: true, cellAttributes: { alignment: 'left' } },
     { label: 'Total Price', fieldName: 'TotalPrice', type: 'currency', sortable: true, cellAttributes: { alignment: 'left' } },
     { label: 'Product', fieldName: 'Product__c', type: 'text', sortable: true, cellAttributes: { alignment: 'left' } },
     { label: 'Sequence Number', fieldName: 'Sequence_Number__c', type: 'number', sortable: true, cellAttributes: { alignment: 'left' } }
];
export default class CustomRelatedList extends LightningElement {

     @track data = [];
     @track columns = columns;
     @api recordId;
     @track loaded = false;
     record = {}

     defaultSortDirection = 'asc';
     sortDirection = 'asc';
     sortedBy = "Sequence_Number__c";

     connectedCallback() {
         this.loadRecords();
     }

     loadRecords() {
          debugger;
          fetchRecords({
               recordId: this.recordId
           }).then(data => {
                if (data) {
                    
               //     data.forEach(x => {
               //         x.RecordUrl = window.location.origin + '/' + x.Id;
              //     });
                     
                     var cloneData = data.map(x => {
                         return {
                             ...x,
                             RecordUrl: window.location.origin + '/' + x.Id
                         };
                     });
                    
                   this.data = cloneData;
                   this.sortedBy = "Sequence_Number__c";
                   this.loaded = true;
               } else if (error) {
                   this.error = error;
                   console.log(error);
               }                
           })
           .catch(error => {
               console.log("Error loading quote products: " + error.status + " " + error.body.message + " " + error.body.stackTrace);
           });
     }
     
}