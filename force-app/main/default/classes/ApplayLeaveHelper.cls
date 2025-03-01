/**
* @author Dinesh B
* @email dinesh.b@utilitarianlab.com
* @create date 2023-09-19 18:19:15
* @modify date 2023-09-19 18:19:15
* @desc [description]
*/

public with sharing class ApplayLeaveHelper {
    
    // For Getting Picklist Leave Types
    @AuraEnabled
    public Static Map<String,String> getPickListValuesMethod(){
        Map<String,String> lstPickvals   = new Map<String,String>();
        try{
            lstPickvals.put('Earned Leave','Earned Leave');
            lstPickvals.put('Sick Leave','Sick Leave');
            lstPickvals.put('Casual Leave','Casual Leave');
            return lstPickvals;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null;
        }
    }
    
    // Method creating Leave Transaction record  Leave
    @AuraEnabled
    public static Leave_Transaction__c insertingLeavTrasRecordFor(String CandidateId,String LeaveDaysCount,Date ApplyStartDate,Date ApplyEndDate,String LeaveDescription,List<Map<String, Object>> leavePlanObj){
        System.debug('CandidateId == >'+CandidateId);
        System.debug('LeaveDaysCount == >'+LeaveDaysCount);
        System.debug('leavePlanObj == >'+leavePlanObj);
        List<Leave_Transaction__c> levTraRecordToInsertList = new List<Leave_Transaction__c>();
        try{
            if(String.isNotBlank(candidateId)  && String.isNotBlank(LeaveDaysCount)){
                Leave_Transaction__c levTraRec = new Leave_Transaction__c();
                levTraRec.Candidate__c = CandidateId;
                levTraRec.Leave_Days__c	 = Decimal.valueOf(LeaveDaysCount);
                levTraRec.Apply_From__c = ApplyStartDate;
                levTraRec.Apply_To__c = ApplyEndDate;
                if( String.isNotBlank(LeaveDescription)){
                    levTraRec.Leave_Description__c = LeaveDescription;
                }
                levTraRecordToInsertList.add(levTraRec);
                if(levTraRecordToInsertList.size()>0){
                    insert levTraRecordToInsertList;
                    System.debug('Inserted Leav Tra Record === >'+levTraRecordToInsertList[0]);
                    if(levTraRecordToInsertList.size()>0){
                          insertLeaveTrascationDetailsRecord(leavePlanObj,levTraRecordToInsertList[0].Id,levTraRec.Candidate__c);
                        return levTraRecordToInsertList[0];
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
// ==================================================================================================================================    
    // Method for creating Leave Transcation Details
    @AuraEnabled 
    public static void insertLeaveTrascationDetailsRecord(List<Map<String, Object>> leavePlanObj,String levTransId,String candidateId){
         System.debug('levTransId: >>> 11 ' + levTransId);
         System.debug('candidateId: >>> 11 ' + candidateId);
         System.debug('leavePlanObj: >>> 11 ' + leavePlanObj);
         List<Leave_Transaction_Details__c> LeaveTransDetailRecordToInsert = new List<Leave_Transaction_Details__c>();
         Leave_Transaction__c levTrans = new Leave_Transaction__c();

            Map<String, Integer> monthMap = new Map<String, Integer>{
            'Jan' => 1, 'Feb' => 2, 'Mar' => 3, 'Apr' => 4, 'May' => 5, 'Jun' => 6,
            'Jul' => 7, 'Aug' => 8, 'Sep' => 9, 'Oct' => 10, 'Nov' => 11, 'Dec' => 12
            };
         if(leavePlanObj !=null){
            for(Map<String,Object> data : leavePlanObj){
                String leavePlan = (String)data.get('leavePlan');
                String selectedDate = (String)data.get('selectedDate');
                System.debug('Selected Date: ' + selectedDate);
                List<String> dateParts = selectedDate.split(' ');
                Integer year = Integer.valueOf(dateParts[3]);
                Integer month = monthMap.get(dateParts[1]);
                Integer day = Integer.valueOf(dateParts[2]);
                  Leave_Transaction_Details__c LevTraDetRec = new Leave_Transaction_Details__c();
                  LevTraDetRec.Leave_Transaction__c = levTransId;
                 // LevTraDetRec.Candidate__c = candidateId;
                  LevTraDetRec.Leave_Date__c= Date.newInstance(year, month, day);
                  if(leavePlan == 'Full Day'){
                      LevTraDetRec.Leave_Days__c = 1;
                  }else{
                      LevTraDetRec.Leave_Days__c = 0.5;
                  }
                  LeaveTransDetailRecordToInsert.add(LevTraDetRec);
            }
             if(LeaveTransDetailRecordToInsert.size()>0){
                  insert LeaveTransDetailRecordToInsert;
                  System.debug('Inserted Record for Leave Transcation Details Size === >'+LeaveTransDetailRecordToInsert.size());
            }
       }
    }
    
}