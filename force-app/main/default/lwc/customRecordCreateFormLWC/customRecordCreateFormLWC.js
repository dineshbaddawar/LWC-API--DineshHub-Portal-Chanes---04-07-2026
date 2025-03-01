import { LightningElement,api,track } from 'lwc';
import getOppFieldSetList from '@salesforce/apex/LWCUtilityHelper.getOppFieldSetList';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CustomRecordCreateFormLWC extends NavigationMixin(LightningElement) {
     oppFiedlSet = [];

     data;
     error;
     @api recordId;
     createdOppRecordId;
     opprecordid;
     selectedAccountId;
     showOpportunityRecordPage = true;
     showSubmitButton = false;
     showNextButton = true;
     showAccountAddress = false;

     connectedCallback() {
          setTimeout(() => {
               this.callApexMethod();
          }, 300);
     }
     callApexMethod() {
          debugger;
          getOppFieldSetList()
               .then(result => {
                    if (result) {
                         this.data = result;
                         var TempArray = [];
                         for (var key in this.data) {           
                              TempArray.push({ key: key, value:(this.data)[key] });             
                         }  
                         this.oppFiedlSet = TempArray;
                         console.log('key', this.oppFiedlSet); 
               }
               })
               .catch(error => {
                    this.error = error;
          })
     }

     handleSuccess(event) {
          debugger;
          console.log('onsuccess event recordEditForm', event.detail.id)
          this.createdOppRecordId = event.detail.id;
          this.opprecordid = event.detail.id;
          this.showOpportunityRecordPage = false;
          this.showNextButton = false;
          this.showSubmitButton = true;
          if (event.detail.fields.AccountId.value != null && event.detail.fields.AccountId.value != undefined) {
               this.showAccountAddress = true;
          } else {
               alert('Please Choose Account, If You want to add Multiple Address');
          }
         

            // Creates the event
            const selectedEvent = new CustomEvent('custevent', {
               detail :  this.createdOppRecordId
          });
          //dispatching the custom event
          this.dispatchEvent(selectedEvent);
        
          }
     closeAction(){
          debugger;
          this.dispatchEvent(new CloseActionScreenEvent());
          window.location.href = 'https://utilitarianlabs-apiorg-dev-ed.lightning.force.com/lightning/o/Opportunity/list?filterName=00B5i00000BVnhoEAD';
     }


    


     handleSubmitButtonClick(event) {
          debugger;
          event.preventDefault(); // Prevent default form submission
          this.template.querySelector('lightning-record-edit-form').submit();
     }
     onchageInputOpp(event) {
          debugger;
          if (event.target.fieldName == 'AccountId') {
               this.selectedAccountId = event.target.value;
          }
         
        //  let fieldAPIname = event.target.fieldName;
     }
     // working
     NextButtonClick(event) {
          debugger;
          event.preventDefault(); // Prevent default form submission
          this.template.querySelector('lightning-record-edit-form').submit();
             
     }
     handleError(event) {
          debugger;
          let message = event.detail.detail;
     }
     handleSubmit(event) {
          debugger;
          console.log('onsubmit event recordEditForm'+ event.detail.fields);
     }
     navigateToRecordPage() {
          debugger;
          this[NavigationMixin.Navigate]({
              type: 'standard__recordPage',
              attributes: {
                  recordId: this.createdOppRecordId,
                  objectApiName: 'Opportunity',
                  actionName: 'view'
              }
          });
     }
     
     successToastMessage() {
          const event = new ShowToastEvent({
              title: 'SUCCESS',
              message: 'Record Created Successfully !',
              variant: 'success',
              mode: 'dismissable'
          });
          this.dispatchEvent(event);
     }
     
     
}