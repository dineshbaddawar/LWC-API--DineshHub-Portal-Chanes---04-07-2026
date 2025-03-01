import { LightningElement, track } from 'lwc';
import getChatGPTResult from '@salesforce/apex/ChatGPT.getChatGPTResult';

export default class ChatGPTSalesforce extends LightningElement {
    @track
    searchTerm='';
    @track
    showSpinner=false;
    @track
    searchResultChatGPT=[];
   
     handleEnterKey(event) {
          debugger;
           if(event.keyCode===13){
            this.searchTerm=event.target.value;
            this.showSpinner=true;

                getChatGPTResult({ searchString: this.searchTerm }).then(result => {
                     debugger;
                let response = JSON.parse(JSON.stringify(JSON.parse(result)));

                if(response.error) {
                    this.searchResultChatGPT = response.error.message;

                  }else if (response.choices[0].text) {
                    this.searchResultChatGPT = response.choices[0].text;
                    this.searchResultChatGPT = this.searchResultChatGPT.replace(/\n/g, "<br />");
                    let tempScriptData = ''
                    tempScriptData = (response.choices[0].text.includes('<script>')) ? 'JS File: ' + response.choices[0].text.split('<script>')[1] : '';
                    tempScriptData = this.responseTextLWCJS.replace(/\n/g, "<br />");


 
                    this.searchResultChatGPT = this.responseData + this.responseTextLWCJS;
                    this.searchResultChatGPT = (this.searchResultChatGPT.includes('XML File:')) ? this.searchResultChatGPT.split('XML File:')[0] : this.searchResultChatGPT;
 
                    this.searchResultChatGPT.trim();
                  }

                  console.log('ss',JSON.stringify(this.searchResultChatGPT));

            }).catch(error=>{
                this.showSpinner = false
                console.log('error is '+error);
            })

        }
     }
    
    
    
}