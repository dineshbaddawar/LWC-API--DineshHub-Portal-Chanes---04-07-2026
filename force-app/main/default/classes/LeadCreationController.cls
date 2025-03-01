public class LeadCreationController {
    public Lead newLead { get; set; }
    
    public LeadCreationController() {
        newLead = new Lead();
    } 
    
    public void saveLead() {
          Lead leadRecordToInsert = (Lead)newLead;
            insert leadRecordToInsert;
    }
}