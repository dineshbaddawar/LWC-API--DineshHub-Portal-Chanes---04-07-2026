import { LightningElement, api, wire, track } from 'lwc';
import getPickListValuesMethod from '@salesforce/apex/ApplayLeaveHelper.getPickListValuesMethod';
import insertingLeavTrasRecordFor from '@salesforce/apex/ApplayLeaveHelper.insertingLeavTrasRecordFor';
import { loadStyle } from "lightning/platformResourceLoader";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LeaveApplayLWC extends LightningElement {
     @api recordId;
     @track leaveTypeList = [];
     @track dateList = [];
     error;
     @track leaveDescription;
     @track showTable = false;
     @track diffStartDate;
     @track diffEndDate;
     @track timeDifference;
     @track diffDays;
     @track timeDifference;
     @track diffDays;
     @track defaultLeaveType = 'Full Day';
     @track dateList = [];
     @track totalDayCount = 0;
     @track intialDayCount= 0;
     @track intialIndex;
     options = [
          { label: 'Half Day', value: 'Half Day' },
          { label: 'Full Day', value: 'Full Day' },
     ];

     connectedCallback() {
          setTimeout(() => {
               this.getPicklistValue();
          }, 300);
     }

     getPicklistValue() {
          debugger;
          getPickListValuesMethod()
               .then(result => {
                    let arr1 = [];
                    if (result) {
                         for (var key in result) {
                              arr1.push({ label: key, value: result[key] });
                         }
                    }
                    this.leaveTypeList = arr1;
               })
               .catch(error => {
                    this.error = error;
               });
     }

     HandleChangeLeaveType(event) {
          debugger;
          this.value = event.detail.value;
     }
     HandleChangedate(event) {
          debugger;

     }
     HandleChangeLeaveReason(event) {
          debugger;
          this.value = event.detail.value;
          this.leaveDescription = this.value;
     }

     handleChangeDays(event) {
          debugger;
          this.value = event.detail.value;
          this.intialIndex = parseInt(event.target.dataset.index);
          if (this.value === 'Half Day') {
               this.intialDayCount = this.intialDayCount + 0.5;
          }
          if (this.value === 'Full Day') {
               this.intialDayCount = this.intialDayCount + 1;
          }
          console.log('Day count ===>' + this.intialDayCount);
          this.dateList[this.intialIndex].leavePlan = this.value;
          this.calculateTotalLeaveCount();
     }

     calculateTotalLeaveCount() {
          debugger;
          let dayCount = 0;
          this.dateList.forEach(leave => {
               dayCount = dayCount + (JSON.stringify(leave.leavePlan) == JSON.stringify('Full Day') ? 1 : 0.5);
          });
          this.totalDayCount = dayCount;
     }

     HandleChangedate(event){
          debugger;
             let value=event.target.value;
             if(event.target.name=='startDate'){
             this.startdate=value;
            }
             if(event.target.name=='endDate'){
             this.enddate=value;
             }
          
          if (this.enddate >= this.startdate) {
               this.showTable = true;
          } else {
               this.showTable = false;
          }
          
          if (this.enddate < this.startdate) {
               // call method
          }

          this.diffStartDate = new Date(this.startdate);
          this.diffEndDate = new Date(this.enddate);
          if (this.diffEndDate != undefined && this.startdate != undefined) {
               this.timeDifference = this.diffEndDate - this.diffStartDate;
               if (this.timeDifference != undefined) {
                    this.diffDays = Math.ceil(this.timeDifference / (1000 * 60 * 60 * 24));
               }
          }

          let dArray = [];
          if (this.diffDays === 0) {
               let currentDate = new Date(this.startdate);
               dArray.push({
                    selectedDate: currentDate.toDateString(),
                    leavePlan: this.defaultLeaveType
               });
          } else {
               for (let i = 1; i <= this.diffDays + 1; i++){
                    let currentDate = new Date(this.startdate);
                    currentDate.setDate(currentDate.getDate() + i - 1);
                    dArray.push({
                         selectedDate: currentDate.toDateString(), leavePlan: this.defaultLeaveType
                    });
               }
          }
          this.dateList = dArray;
          this.calculateTotalLeaveCount();
     }

     hanldeProgressValueChange(event) {
          debugger;
         this.selectedRecordIdFromParent = event.detail;
        // this.getRecordDetails();
     }
     
     HandleSumbit() {
          debugger;
          insertingLeavTrasRecordFor({
               CandidateId: this.recordId,
               LeaveDaysCount: this.totalDayCount,
               ApplyStartDate: this.startdate,
               ApplyEndDate: this.enddate,
               LeaveDescription: this.leaveDescription,
               leavePlanObj : this.dateList
          })
               .then(result => {
               if (result) {
               this.showSuccessMessage();
               var BaseURL =  window.location.href.slice(0,58);
               window.location.replace( BaseURL+'lightning/r/Leave_Transaction__c/'+result.Id+'/view');
               }
               })
               .catch(error => {
                this.error = this.showErrorToast();
          })
     }

     
    showErrorToast() {
     const evt = new ShowToastEvent({
         title: 'ERROR',
         message: 'Some unexpected error',
         variant: 'error',
         mode: 'dismissable'
     });
     this.dispatchEvent(evt);
    }
     
    showSuccessMessage(){
     const evt = new ShowToastEvent({
     title: 'SUCCESS',
     message: 'Leave Applied Successfully !',
     variant: 'success',
     mode: 'dismissable'
     });
     this.dispatchEvent(evt);
 }
     
}