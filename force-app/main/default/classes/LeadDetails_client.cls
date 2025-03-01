public class LeadDetails_client {
    
    public String FN;
    public String LN;
    public String EmailAddress;
    public String Phone;
    public String Company;
    public string LeadSource;
    public static LeadDetails_client parse(String json) {
        return (LeadDetails_client) System.JSON.deserialize(json, LeadDetails_client.class);
    }
	}