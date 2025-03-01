import { LightningElement,api,track,wire } from 'lwc';
import  getopplineitmeRecord from '@salesforce/apex/LWCUtilityHelper.getOpplineItemUnderopp';
import  SaveOpplineitem from '@salesforce/apex/LWCUtilityHelper.updateOpplineItem';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from 'lightning/alert';
export default class UpsertOppLineItem extends LightningElement {

@api recordId;
@track oppLineItem = [];
@track error;
  disable_savebutton = false;
    textid;
    textvalue;

@wire(getopplineitmeRecord,{recordId : '$recordId'})
callMethod({error,data}){
    debugger;
    if(data){
        this.oppLineItem = data;
    }else{
        this.error = error;
    }
}

 handleChange(event) {
        debugger;
        this.textid = event.target.dataset.id;
        this.textvalue = event.target.value;
        let opplineDetails = this.oppLineItem;
        let opplineDetailsList = [];

        opplineDetails.forEach(opp =>{
            if(this.textid == opp.Id){
              opplineDetailsList.push({
                  Id: opp.Id ? opp.Id : "",
                  Description : this.textvalue ? this.textvalue : "",
                  Quantity : opp.Quantity ? opp.Quantity : "",
                  TotalPrice : opp.TotalPrice ? opp.TotalPrice : "",
                  UnitPrice : opp.UnitPrice ? opp.UnitPrice : ""
              })
            }else{
                 opplineDetailsList.push({
                  Id: opp.Id ? opp.Id : "",
                  Description : opp.Description ? opp.Description : "",
                  Quantity : opp.Quantity ? opp.Quantity : "",
                  TotalPrice : opp.TotalPrice ? opp.TotalPrice : "",
                  UnitPrice : opp.UnitPrice ? opp.UnitPrice : ""
              })
            }
        })
        this.oppLineItem = opplineDetailsList;
 }

   handleClick() {
        debugger;
        this.disable_savebutton = true;
        SaveOpplineitem({ updateOpplineList: this.oppLineItem }).then(result => {
            debugger;
            if (result) {
                this.showSuccessToastQuoteSaved();
                this.closeQuickAction();
                this.refreshPage();
            }
        }).catch(err => {
            console.log('err::' + err);
        })
    }

 showSuccessToastQuoteSaved() {
        const event = new ShowToastEvent({
            title: 'Quote Line Items Updated',
            message: 'Quote Line Items Updated Successfully!',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);

    }
    closeQuickAction() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
       // this.dispatchEvent(new RefreshEvent());
    }


      refreshPage(){

        this.dispatchEvent(new CloseActionScreenEvent());

        //window.location.reload();

        if(window && this.recordId) {

            window.location.href='/lightning/r/Opportunity/'+this.recordId+'/view';

        }

    }


}