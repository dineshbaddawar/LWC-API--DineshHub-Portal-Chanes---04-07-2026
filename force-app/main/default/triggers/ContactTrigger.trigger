trigger ContactTrigger on Contact (before insert,before update,before delete,after delete,after insert,after update,after undelete) {

   
    if(trigger.isBefore && trigger.isDelete){
        ContactTriggerHelper.BeforeDeleteContactUpdateAccountPhone(trigger.oldmap,trigger.newmap);
    }
    
     UtilityClass util = new UtilityClass();
    if(trigger.isAfter && trigger.isInsert){
        util.AfterInsert(trigger.newMap);
         PINCodeAPI.afterInsertContactPindCode(trigger.new);
    }

    if(trigger.isAfter && trigger.isDelete){
        util.AfterDelete(trigger.oldMap);
    }

    if(trigger.isAfter && trigger.isUndelete){
        util.AfterUnDelete(trigger.newMap);
    }
}