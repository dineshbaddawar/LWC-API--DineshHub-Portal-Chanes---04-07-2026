public class OpportunityCloneController {

    Static final String SELECT_CLAUSE = 'SELECT ';
    Static final String WHERE_CLAUSE = 'WHERE ';
    
    @AuraEnabled(cacheable=true)
    Public Static Opportunity GetCloneDataOpp(String oppId){
        List<Schema.FieldSetMember> getFieldSet = SobjectType.Opportunity.FieldSets.FiledSet_Opp.getFields();
        List<String> FieldSetToAdd = new List<String>();
        try{
            for(FieldSetMember fieldSet : getFieldSet){
                FieldSetToAdd.add(String.valueOf(fieldSet.sobjectfield));
            }
            String query = SELECT_CLAUSE + String.join(FieldSetToAdd, ',');
            query += ' FROM Opportunity '+WHERE_CLAUSE+ 'Id =: oppId';
            System.debug('The Query ================ '+query);
            return Database.query(query);
        }catch(Exception e){
            System.debug('The Error  :'+e.getMessage());
            System.debug('The Error Line :'+e.getLineNumber());
        }
        return null;
    }
}