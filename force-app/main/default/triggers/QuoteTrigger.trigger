trigger QuoteTrigger on Quote (before insert) {
    // Map to store the count of quotes for each Opportunity
    Map<Id, Integer> opportunityQuoteCountMap = new Map<Id, Integer>();
    
    // Loop through the quotes to count how many quotes each Opportunity has
    for (Quote newQuote : Trigger.new) {
        if (newQuote.OpportunityId != null) {
            if (!opportunityQuoteCountMap.containsKey(newQuote.OpportunityId)) {
                opportunityQuoteCountMap.put(newQuote.OpportunityId, 1);
            } else {
                opportunityQuoteCountMap.put(newQuote.OpportunityId, opportunityQuoteCountMap.get(newQuote.OpportunityId) + 1);
            }
        }
    }
    
    // Loop through the quotes again to set the Quote Name
    for (Quote newQuote : Trigger.new) {
        if (newQuote.OpportunityId != null) {
            Integer quoteCount = opportunityQuoteCountMap.get(newQuote.OpportunityId);
            
            if (quoteCount == null) {
                quoteCount = 1;
            }
            
            String quoteNamePrefix = 'Quote-' + String.valueOf(quoteCount).leftPad(3, '0') + '/' + String.valueOf(quoteCount);
            
            newQuote.Name = quoteNamePrefix;
        }
    }
    
}