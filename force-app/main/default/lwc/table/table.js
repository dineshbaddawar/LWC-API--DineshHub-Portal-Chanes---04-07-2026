import { LightningElement,api,track,wire } from 'lwc';

export default class Table extends LightningElement {
     @api records;
     @track enableTopBar = true;
     @api enableUpload = false;
     @api displayRowNumber = false;
     @api displayRowSelect = false;
     @api selectMultiple = false;
     @track isSelectActive = false;
     @track dataLoaded = false;
     @api resizable = false;
     @api selectText = 'On Selected';
     @api columns;
     @api uploadFunction;
     @api selectFunction;
     @api pageSize = 10;
     @api maxPageSize = 100;
     @track pageCurrent = 1;
     @track maxPage;
     @track recordCount;
     @track pagedRecords;
     @track searchRecords;
     @track sortLabel = 'RowId';
     @track currentSort = { Column: "RowId", Direction: "asc"};
     @track pageLibrary = [];
     @track pageButtons = [];
     @track formatter = new Intl.NumberFormat('en-US', {
          style: 'currency',
          currency: 'USD',
     });
     
     @track firstRender = true;
     renderedCallback() {
          debugger;
          this.template.querySelectorAll('.page-size').forEach(x => {
               if (this.pageSize == undefined) this.pageSize = "";
               if (x.name == this.pageSize.toString()) {
                    x.variant = 'brand';
               } else {
                    x.variant = 'brand-outline';
               }
          });
          if (this.firstRender && (this.resizable == true || this.resizable == 'true')) {
               this.firstRender = false;
               this.handleResize();
          }
     }
     handleResize = function () {
          debugger;
          
     };

     handleUpload = function () {
          debugger;
          console.log(uploadFunction);
          this.uploadFunction();
     };

     handleSelectFunctionCall = function () {
          debugger;
          this.selectFunction(this.records);
     };
     
     handlePageChange = function (event) {
          debugger;
          var name = event.target.name;
          if (name == 'Next') {
               var nextPage = parseInt(this.currentPage) + 1;
               if (nextPage <= parseInt(this, maxPage)) {
                    this.currentPage = nextPage.toString();
                    this.handlePopulatePage();
               }
          }
          else if (name == 'Back') {
               var lastPage = parseInt(this.currentPage) - 1;
               if (lastPage >= 1) {
                    this.currentPage = lastPage.toString();
                    this.handlePopulatePage();
               }
          }
          else {
               var value = event.target.value;
               this.currentPage = value;
               this.handlePopulatePage();
          }
     };

     handleRowSelect = function (event) {
          debugger;
          const value = event.target.value;
          const checked = event.target.checked;
     };

     handleSort = function (event) {
          debugger;
          let column = event.target.dataset.id;
          this.sortLabel = column;
          if (this.currentSort.Column == column && this.currentSort.Direction == 'asc') {
               
          }
     };

     handlePageSizeChange = function (event) {
          debugger;
          var name = event.target.name;
          this.pageSize = parseInt(name);
          this.pageCurrent = 1;
          this.template.querySelectorAll('.page-size').forEach(x => {
               console.log('page size details === >' + x);
               if (x.name == name) x.variant = "brand";
               else x.variant = "brand-outline";
          });
          this.buildPage();
     };

     handleSearch = function (event) {
          debugger;
          let sValue = event != undefined ? event.target.value : '';
          var tempData = this.records.filter(x => {
               let match = false;
               Object.entries(x).forEach(([key, value]) => {
                    if (key != 'values' && x[key] != undefined && x[key] != null && x[key].toString().toLowerCase().includes(sValue.toString().toLowerCase()))
                         match = true;
               });
               return match;
          });
          var pages = parseInt(Math.ceil(tempData.length / this.pageSize));
          this.maxPage = pages;
          this.pageLibrary = [];
          for (var i = 1; i <= pages; i++) {
               this.pageLibrary.push({ value: i, label: i });
          }
          this.searchRecords = tempData;
          this.currentPage = 1;
          
          if (this.columns.filter(e => e.fieldName == this.sortLabel)[0] != undefined) {
               if (this.currentSort.Direction == 'asc') {
                    this.handleSortAsc();
               } else {
                    this.handleSortDesc();
               }
               //      Othery Way doing above
               //      if (this.currentSort.Direction == "asc") this.handleSortAsc();
               //     else this.handleSortDesc();
               
          }
          this.handlePopulatePage();

     };

     connectedCallback() {
          debugger;
          if (this.enableUpload == undefined) this.enableUpload = false;
          let tempList = [];
          let index = 1;
          if (this.displayRowNumber == true || this.displayRowNumber == "true") {
               var newArray = this.columns.slice();
               newArray.unshift({label: '#',fieldName: 'RowId',  type: 'number', sortable: true });
               this.columns = newArray;
          }
          if (this.displayRowSelect == true || this.displayRowSelect == "true") {
               var newArray = this.columns.slice();
               newArray.unshift({label: '',fieldName: 'Select',  type: 'select', onclick: this.handleRowSelect, isSelect : true, sortable: false });
               this.columns = newArray;
          }
          if (this.pageSize == undefined) this.pageSize = "50";
          if (this.pageSize.toString().toLowerCase() == "all"){
            this.enableTopBar = false;
            this.pageSize = 10000;
          }
          if (this.maxPageSize >= 10) this.pageButtons.push("10");
          if (this.maxPageSize >= 25) this.pageButtons.push("25");
          if (this.maxPageSize >= 50) this.pageButtons.push("50");
          if (this.maxPageSize >= 100) this.pageButtons.push("100");
          if (this.maxPageSize >= 250) this.pageButtons.push("250");
          if (this.maxPageSize >= 500) this.pageButtons.push("500");

          this.records.forEach(x => {
               let _x = {};
               for (let key of Object.keys(x)) {
                    _x[key] = x[key];
               }
               _x.values = [];
               _x.RowId = index.toString();

               this.columns.forEach(y => {
                    if (y.type != undefined && y.type == 'url') {
                         _x.values.push({
                              key: y.fieldName, 
                              url: x[y.fieldName],
                              value : x[y.typeAttributes.label.fieldName], 
                              style: y.dataStyle,
                              isUrl: true,
                              target: y.typeAttributes.target
                          });
                    } else if (y.type != undefined && y.type == 'currency') {
                         _x.values.push({
                              key: y.fieldName, 
                              value : x[y.fieldName] != undefined ? this.formatter.format(x[y.fieldName]) : '', 
                              style: y.dataStyle,
                              isValue : true
                          });
                    } else if (y.type != undefined && y.type == 'icon') {
                         _x.values.push({
                              key: y.fieldName, 
                              value : x[y.fieldName], 
                              style: y.dataStyle,
                              isIcon : true
                          });
                    } else if (y.type != undefined && y.type == 'select') {
                         _x.values.push({
                              key: y.fieldName,
                              style: y.dataStyle,
                              isSelect : true,
                              onclick: this.rowSelect
                          });
                    } else if (y.type != undefined && y.type == 'action') {
                          _x.values.push({
                               key: y.fieldName,
                               style: y.dataStyle,
                               isAction : true,
                               actions : y.actions
                          });
                    } else if (y.type != undefined && y.type == 'date') {
                         var date = new Date(x[y.fieldName]);
                         _x.values.push({
                         key: y.fieldName, 
                         value : x[y.fieldName] != undefined ? (date.getMonth() + 1) + '/' + date.getDate() + '/' +  date.getFullYear() : '', 
                         style: y.dataStyle,
                         isValue : true
                         });
                    } else if (y.fieldName == 'RowId') {
                         _x.values.push({
                              key: y.fieldName, 
                              value : index.toString(), 
                              style: y.dataStyle,
                              isValue : true
                          });
                    } else {
                         _x.values.push({
                              key: y.fieldName, 
                              value : x[y.fieldName], 
                              style: y.dataStyle,
                              isValue : true
                          });
                    }
               });
               tempList.push(_x);
               index++;
          });

          this.records = tempList;
          console.log('Records == >' + this.records);
          this.recordCount = this.records.length;
          this.buildPage();
          this.dataLoaded = true;
     };


     buildPage = function () {
          debugger;
          var pages = parseInt(Math.ceil(this.records.length / this.pageSize))
          this.maxPage = pages == 0 ? 1 : pages;
          this.pageLibrary = [];
          for (var i = 1; i <= pages; i++) {
               this.pageLibrary.push({ value: i, label: i });
          }
          this.handleSearch();
     };

     handleSortAsc = function () {
          debugger;
          console.log('handleSortAsc == >' + this.sortLabel);
          let currentColumn = this.columns.filter(x => { return x.fieldName == this.sortLabel; })[0];

          if (currentColumn.type == 'date' || currentColumn.type == 'datetime') {
               this.searchRecords = this.searchRecords.sort((x, y) => {
                    var date1 = new Date(x[this.sortLabel]),
                         date2 = new Date(y[this.sortLabel]);
                    return date1 < date2 ? -1 : (date1 > date2 ? 1 : 0);
               })
          }
          else if (this.sortLabel == 'RowId') {
               this.searchRecords = this.searchRecords.sort((x, y) => {
                    return parseInt(x[this.sortLabel]) < parseInt(y[this.sortLabel]) ? -1 : 0;
               });
          }
          else if (currentColumn.type == 'url') {
               let displayFieldName = currentColumn.typeAttributes.label.fieldName;
               this.searchRecords = this.searchRecords.sort((x, y) => {
                    return x[displayFieldName] > y[displayFieldName] ? 1 : x[displayFieldName] < y[displayFieldName] ? -1 : 0
               });
          } else {
               this.searchRecords = this.searchRecords.sort((x, y) => {
                    return x[this.sortLabel] == undefined || x[this.sortLabel] == '' ? 1 :
                         y[this.sortLabel] == undefined || y[this.sortLabel] == '' ? -1 :
                              x[this.sortLabel] > y[this.sortLabel] ? 1 :
                                   x[this.sortLabel] < y[this.sortLabel] ? -1 : 0
               });
          }
          this.currentSort.Column = this.sortLabel;
          this.currentSort.Direction = 'asc';
     };
     handleSortDesc = function () {
          debugger;
     };

     handlePopulatePage = function () {
          debugger;
          this.pagedRecords = [];
          var temp = [];
          var firstIndex = ((parseInt(this.currentPage) - 1) * this.pageSize);
          var lastIndex = (((parseInt(this.currentPage)) * this.pageSize));

          if (lastIndex > this.searchRecords.length) {
               lastIndex = this.searchRecords.length;
          }
          // Short way to show above Experssion
          // if (lastIndex > this.searchRecords.length) lastIndex = this.searchRecords.length;
          for (var i = firstIndex; i < lastIndex; i++) {
               temp.push(this.searchRecords[i]);
          }
          this.pagedRecords = temp;
     };
}