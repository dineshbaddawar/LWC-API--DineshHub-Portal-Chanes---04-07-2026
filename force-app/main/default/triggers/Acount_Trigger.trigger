trigger Acount_Trigger on Account (before insert, after insert, after update, before update, after delete, after undelete,before delete) {

    if(trigger.isDelete && trigger.isBefore){
        Trigger_Helper_Classes.PreventAccountDeletion(trigger.old);
    }
}