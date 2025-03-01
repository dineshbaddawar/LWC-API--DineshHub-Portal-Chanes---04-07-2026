public with sharing class RazorpayPaymentLWCController {
    
    @AuraEnabled
    public static string initatePayment(Id recordId){
        try {
            return RazorpayPaymentHandler.sendPaymentLink(recordId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}