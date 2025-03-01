import { LightningElement, wire,api,track } from 'lwc';
import getAccounts from '@salesforce/apex/LWCUtilityHelper.getAccounts';
import {loadStyle} from 'lightning/platformResourceLoader';
import COLORS from '@salesforce/resourceUrl/colors';
import OWNERSHIP_FIELD from '@salesforce/schema/Account.Ownership';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import GetPicklistFieldValuesDynamically from '@salesforce/apex/LWCUtilityHelper.GetPicklistFieldValuesDynamically';
const COLUMNS = [
    {label:'Account Name', fieldName:'Name',  cellAttributes:{
        class:{fieldName:'accountColor'}
    }},
    {label:'Annual Revenue', fieldName:'AnnualRevenue', type:'currency', cellAttributes:{
        class:{fieldName:'amountColor'},
        iconName:{fieldName:'iconName'}, iconPosition:'right'
    }},
    {label:'Industry', fieldName:'Industry', type:'text', cellAttributes:{
        class:{fieldName:'industryColor'}
    }},
    {label:'Phone', fieldName:'Phone', type:'phone'},
]
export default class DatatableStylinginLWC extends LightningElement {
 tableData
    columns = COLUMNS
    isCssLoaded = false


    // With using Apex
    @track objectApiName = 'Account';
    @track fieldApiName = 'Industry';
    @track picklistFieldValues = [];
    @track value = '';


    connectedCallback(){
       this.fetchPicklistFields();
    }
    fetchPicklistFields() {
        debugger;
        GetPicklistFieldValuesDynamically({
          objectName : this.objectApiName,
          fieldName : this.fieldApiName,
      })
      .then((result) => {
          console.log('fetchPicklistFields');
          this.picklistFieldValues = [
             {
                 "label": "--None--",
                 "value": ""
             },
             ...result
         ];
         console.log(this.picklistFieldValues);
      })
      .catch((error) => {
         console.error(error);
      });
    }

    // Without using Apex
   OwnerShipoptions = [];
      @wire( getObjectInfo, { objectApiName: ACCOUNT_OBJECT } )
    objectInfo;

    @wire( getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: OWNERSHIP_FIELD } )
    wiredIndustryData( { error, data } ) {
        console.log( 'Inside Industry Get Picklist Values' );
        if ( data ) {
            this.OwnerShipoptions = data.values;
        } else if ( error ) {
            console.error( 'Error in Industry picklist field', JSON.stringify( error ) );
        }
    }

    // with using Apex Class
    @wire(getAccounts)
    accountsHandler({data, error}){ 
        if(data){ 
            debugger;
            this.tableData = data.map(item=>{
                let amountColor = item.AnnualRevenue <500000 ? "slds-text-color_error":"slds-text-color_success"
                let iconName = item.AnnualRevenue <500000 ? "utility:down":"utility:up"
                return {...item, 
                    "amountColor":amountColor,
                    "iconName":iconName,
                    "industryColor":"slds-icon-custom-custom12 slds-text-color_default",
                    "accountColor":"datatable-orange"
                }
            })
            console.log(this.tableData)
        }
        if(error){
            console.error(error)
        }
    }

    renderedCallback(){ 
        debugger;
        if(this.isCssLoaded) return
        this.isCssLoaded = true
        loadStyle(this, COLORS).then(()=>{
            console.log("Loaded Successfully")
        }).catch(error=>{ 
            console.error("Error in loading the colors")
        })
    }
    handlechange(event){
        debugger;
        var pickvalue = event.target.value;
    }
    handleChangeApex(event){
        debugger;
        var apexValue = event.target.value;
    }
}