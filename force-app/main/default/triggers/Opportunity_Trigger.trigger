trigger Opportunity_Trigger on Opportunity (before insert, after insert, after update, before update, after delete, after undelete,before delete) {

    if(trigger.isAfter && trigger.isInsert || trigger.isAfter && trigger.isUpdate){
        Trigger_Helper_Classes.getLatestOpportunityAmount(trigger.new);
    }
}