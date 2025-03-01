public with sharing class TaskDetails {
  
    public String WhoId;
    public String OwnerId;
    public String callDuration;
    public String status;
    public String Subject;
    public static TaskDetails parse(String json){
        return (TaskDetails) System.JSON.deserialize(json, TaskDetails.class);
    }
}