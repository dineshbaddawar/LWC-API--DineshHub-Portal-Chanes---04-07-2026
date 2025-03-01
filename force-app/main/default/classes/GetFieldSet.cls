public class GetFieldSet {
      // APEX CLASS
    static final String SELECT_CLAUSE = 'SELECT ';
    static final String WHERE_CLAUSE = 'WHERE';
    
    @AuraEnabled(cacheable=true)
    public Static Opportunity getFieldFromFieldSet( String oppId){
        System.debug('OppIdddd-----'+oppId);
        List<Schema.FieldSetMember> FieldSetListFromOPp  = SobjectType.Opportunity.FieldSets.FiledSet_Opp.getFields();
        List<String> FieldSet = new List<String>();
        try{
            for(Schema.FieldSetMember fieldsToAdd : FieldSetListFromOPp){
                FieldSet.add(String.valueOf(fieldsToAdd.sobjectfield));
            }
            String query = SELECT_CLAUSE + String.join(FieldSet, ',');
                    System.debug('OppIdddd-----'+query);
            query += ' FROM Opportunity '+ WHERE_CLAUSE+' Id =: oppId';
            return Database.query(query);
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
     /*
LWC:

JS FILE

import { LightningElement, wire, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getFieldFromFieldSet from '@salesforce/apex/GetFieldSet.getFieldFromFieldSet';

export default class NavToNewRecord extends NavigationMixin(LightningElement) {
@api recordId;
@track result;
// @track mapData = [];

// connectedCallback() {
//     // initialize component
// }

@wire(getFieldFromFieldSet, { oppId: '$recordId' })
getOppRecords({ error, data }) {
debugger;
console.log('data====', data);
if (data != null) {
//var datJSON = JSON.stringify(data);

//    delete data.attributes;
//this.result = data;
// var conts = data;
// for (var key in conts) {
//     this.mapData.push({ value: conts[key], key: key }); //Here we are creating the array to show on UI.
// }
//this.mapData = data;

//console.log('data After====', mapData);
this.navigateToNewContactWithDefaults(data);

} else {
console.log('The Error --> ' + error);
}
}

navigateToNewContactWithDefaults(datJSON) {
const defaultValues = encodeDefaultFieldValues(datJSON);
this[NavigationMixin.Navigate]({
type: 'standard__objectPage',
attributes: {
objectApiName: 'Opportunity',
actionName: 'new'
},
state: {
defaultFieldValues: defaultValues
}
});
}
}


XML

<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
<apiVersion>52.0</apiVersion>
<isExposed>true</isExposed>
<targets>
<target>lightning__RecordAction</target>
<target>lightning__RecordPage</target>
</targets>
<targetConfigs>
<targetConfig targets="lightning__RecordAction">
<actionType>ScreenAction</actionType>
</targetConfig>
</targetConfigs>
</LightningComponentBundle>

*/
}