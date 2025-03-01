// Wrapper class for Inserting Opportunity usin REST API
public class OpportunityDetails {

    public String Name;
    public Decimal OppAmount;
    public Date OppcloseDate;
    public String OppNextStep;
    public String OppAccountId;
    public String OppStage;
    public String Opptype;
    public Integer OppProbality;
    public String OppleadSource;
    public String OppEmail;
    public String OppUrl;
    public String OppPhone;
    
    public Static OpportunityDetails parse(String json){
        return (OpportunityDetails) System.JSON.deserialize(json, OpportunityDetails.class);
    }
}