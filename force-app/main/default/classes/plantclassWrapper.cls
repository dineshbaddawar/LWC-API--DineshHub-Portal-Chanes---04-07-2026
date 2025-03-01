// Wrapper Json Body
public class plantclassWrapper {
    
    public String plant_date;
    public String plant_age;
    public String plant_desc;
    public String plant_type;
    public static plantclassWrapper parse(String json) {
        return (plantclassWrapper) System.JSON.deserialize(json, plantclassWrapper.class);
    }
}