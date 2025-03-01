import { LightningElement, wire } from 'lwc';
import getAllInvoiceRecords from '@salesforce/apex/LWCUtilityHelper.getAllInvoiceRecords';
export default class GetInvoiceMapComp extends LightningElement {

  result;
  error;
  invoiceMap = new Map();
  options = [];
  keyList = [];
  selectedValue = '';
  invoicerecordList = [];
  selectedIdList = [];
  pageSizeOptions = [5, 10, 15, 20];
  pageSize;
  totalRecords = 0;
  pageNumber = 1;
  recordsToDisplay = [];

  columns = [
    {
      label: 'Invoice ID',
      fieldName: 'Id',
      type: 'text'
    },
    {
      label: 'Invoice Name',
      fieldName: 'Name',
      type: 'text'
    },
    {
      label: 'Status',
      fieldName: 'Status__c',
      type: 'text'
    }
  ];

  @wire(getAllInvoiceRecords)
  getMapdata({ error, data }) {
    debugger;
    if (data) {
      var realizedCount = data.Realized.length;
      var pendingCount = data.Pending.length;
      this.totalRecords = realizedCount + pendingCount;
      this.pageSize = this.pageSizeOptions[0];

      Object.keys(data).forEach(key => {
        this.invoiceMap.set(key, data[key]);
        this.keyList.push(key);
      });
      this.options = this.keyList.map(item => ({
        label: item,
        value: item
      }));
    } else {
      this.totalRecords = 0;
    }
  }

  handleChange(event) {
    debugger;
    this.selectedValue = event.detail.value;
    this.invoicerecordList = this.invoiceMap.get(this.selectedValue) || [];
    this.paginationHelper(1);
  }

  handleRowSelection(event) {
    debugger;
    const selectedRows = event.detail.selectedRows;
    var recordid = selectedRows[0]?.Id;
    this.selectedIdList = selectedRows.map(item => item.Id);
  }

  handleRecordsPerPage(event) {
    debugger;
    this.pageSize = event.target.value;
     this.paginationHelper();
  }

  paginationHelper() {
    debugger;
    this.recordsToDisplay = [];
    this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    if (this.pageNumber <= 1) {
      this.pageNumber = 1;
    } else if (this.pageNumber >= this.totalPages) {
      this.pageNumber = this.totalPages;
    }

    for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
      if (i === this.totalRecords) {
        break;
      }
      this.recordsToDisplay.push(this.invoicerecordList[i]);
    }
  }

}