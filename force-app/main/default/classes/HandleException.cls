public class HandleException extends Exception {
    
    public Static void  captureError(String ClassName, String methodName, Exception ex){
        Exception__c newException = CreateErrorMsg(ClassName, methodName , ex);
        insertError(newException);
    }
    
    public Static Exception__c CreateErrorMsg(String ClassName, String methodName, Exception ex){
        try{
            Exception__c exp =   new Exception__c();
            exp.Class_Name__c = ClassName;
            exp.Method_Name__c = methodName;
            exp.Error_Message__c = ex.getMessage();
            exp.Stack_Trace__c = ex.getStackTraceString();
            exp.Error_Line_No__c = ex.getLineNumber();
            exp.Error_Type__c = ex.getTypeName();
            insert exp;
            return exp;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    public static void insertError(Exception__c exceps){
        try{
            Database.insert(exceps, false);
        }
        catch(DMLException dmlError){}
    }
}