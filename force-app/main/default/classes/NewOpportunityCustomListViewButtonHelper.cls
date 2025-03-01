public class NewOpportunityCustomListViewButtonHelper {

      public NewOpportunityCustomListViewButtonHelper(ApexPages.StandardSetController cntlr){
        System.debug('cntlr Selected ===>'+cntlr.getSelected());
       
    }
    
    public PageReference redirectToLC(){
        String returnUrl = '/lightning/n/Custom_New?'; 
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
}