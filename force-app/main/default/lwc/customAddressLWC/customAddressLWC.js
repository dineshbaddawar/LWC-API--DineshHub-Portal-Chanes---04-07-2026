import { LightningElement,api,wire,track} from 'lwc';
import getAllAddresses from "@salesforce/apex/LWCUtilityHelper.getAllCustomerAddress";
import { CloseActionScreenEvent } from 'lightning/actions';
import updateOpportunityAddress from '@salesforce/apex/LWCUtilityHelper.updateOpportunityAddress';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CustomAddressLWC extends LightningElement {
    @api recordId;
    @api createdOppRecordId;
    @api opprecordid;
    shippingDetails;
    billingDetails;
     selectedShippingAddressIndex = -1;
     selectedBilAddressIndex = -1;
     @track ship_addresses = [];
     @track bill_addresses = [];
     error;
     @track checkedShipAdd;
     @track checkedBillAdd
     @track accRecord;

     connectedCallback(){
          setTimeout(() => {
              this.getRecordDetails();
          }, 300);
     }
     
     getRecordDetails() {
          debugger;
          getAllAddresses({recordId : this.recordId}).then(data => {
              if(data){
                  debugger;
                  let clonedData = JSON.parse(JSON.stringify(data));
                  console.log('Data',clonedData);
                  this.accRecord = clonedData.account;
                  this.ship_addresses = clonedData.customer_ship_addresses;
                  this.bill_addresses = clonedData.customer_bill_addresses;

                  this.selectedShippingAddressIndex = clonedData.ship_selected_index != undefined ? clonedData.ship_selected_index : -1;
                  this.selectedBilAddressIndex = clonedData.bill_selected_index != undefined ? clonedData.bill_selected_index : -1;

              }
         })
     }
    
    onShippingAddressSelect(event) {
        debugger;
        let addressId = event.currentTarget.dataset.id;
        let selectedIndex = event.currentTarget.dataset.index;
        this.checkedShipAdd = event.target.checked;

        if(this.checkedBillAdd==undefined){
           this.checkedBillAdd=true;
        }   
      if(addressId && selectedIndex ) {
       if(this.selectedShippingAddressIndex !== -1)
          this.ship_addresses[this.selectedShippingAddressIndex].checked = false;
          this.ship_addresses[selectedIndex].checked = true;
          this.selectedShippingAddressIndex = selectedIndex;
      }
    }
    
    onBillingAddressSelect(event) {
        debugger;
        let addressId = event.currentTarget.dataset.id;
        let selectedIndex = event.currentTarget.dataset.index;
        this.checkedBillAdd = event.target.checked;   

        if(this.checkedShipAdd==undefined){
            this.checkedShipAdd=true;
        }
      if(addressId && selectedIndex ) {
       if(this.selectedBilAddressIndex !== -1)
          this.bill_addresses[this.selectedBilAddressIndex].checked = false;
          this.bill_addresses[selectedIndex].checked = true;
          this.selectedBilAddressIndex = selectedIndex;
      }
    }
    handleNavigate() {
        debugger;
        let opprecordIdfromParent = this.opprecordid;
        let index = this.ship_addresses.findIndex((item) => {
            return item.checked === true;
        });

        let billingIndex = this.bill_addresses.findIndex((item) => {
            return item.checked === true;
        });
        if(index === -1 || billingIndex === -1) {
            const evt = new ShowToastEvent({
                title: "No Selection",
                message: "Please select Shipping and Billing address in-order to proceed.",
                variant: "Warning",
            });
            this.dispatchEvent(evt);
            return;
        }

        let selectedShippingAddressIndex = this.ship_addresses[index];
        
        let addressId = selectedShippingAddressIndex.id;
        let accShipAddress = false;

        let selectedBillingAddress = this.bill_addresses[billingIndex];
        let billAddressId = selectedBillingAddress.id;
        let accountBillAddress = false;
        
        if (selectedShippingAddressIndex.id === 'Shipping') {
            this.shippingDetails = selectedShippingAddressIndex.id;
            addressId = undefined;
            accShipAddress = true;
        } else {
            this.shippingDetails = selectedShippingAddressIndex.id;
        }
        
        if (selectedBillingAddress.id === 'Billing') {
            this.billingDetails = selectedBillingAddress.id;
            billAddressId = undefined;
            accountBillAddress = true;
        } else {
            this.billingDetails = selectedBillingAddress.id;
        }

        if(selectedShippingAddressIndex.state != null && selectedShippingAddressIndex.city != null && selectedShippingAddressIndex.country != null && selectedShippingAddressIndex.street != null && selectedShippingAddressIndex.postalCode != null &&
           selectedBillingAddress.state != null && selectedBillingAddress.city != null && selectedBillingAddress.country && selectedBillingAddress.postalCode != null && selectedBillingAddress.street != null){
         //  this.openCreateRecordForm(addressId, accShipAddress, billAddressId, accountBillAddress);
        }else{
            alert('Selected Address should save the all data');
            
        }
        updateOpportunityAddress({ shippingData: this.shippingDetails, billingData: this.billingDetails, accountId: this.recordId, opportunityId: this.opprecordid })
            .then(result => {
                if (result == 'SUCCESS') {
                    this.showToast();
                    window.location.href = 'https://utilitarianlabs-apiorg-dev-ed.lightning.force.com/lightning/r/Opportunity/'+this.opprecordid+'/view'
                    
                } else {
                    alert('Something went wrong !');
               }
            })
            .catch(error => {
                this.error = error;
        })

    }

    closeAction(){
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
        window.location.href = 'https://utilitarianlabs-apiorg-dev-ed.lightning.force.com/lightning/o/Opportunity/list?filterName=00B5i00000BVnhoEAD';
    }
    showToast() {
        const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'Record Created Successfully !',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}