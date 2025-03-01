trigger LeadTrigger on Lead (before insert) {

    if(trigger.isBefore && trigger.isInsert){
        Trigger_Helper_Classes.PreventDuplicateLeadRecord(trigger.new);
    }
}