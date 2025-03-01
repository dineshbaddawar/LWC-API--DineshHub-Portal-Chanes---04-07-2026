trigger OpportunityTrigger on Opportunity (before insert,after insert) {

    if(trigger.isAfter && trigger.isInsert){
        CurrencyConvertAPI.oppAmountINRtoUSD(trigger.new);
    }
}