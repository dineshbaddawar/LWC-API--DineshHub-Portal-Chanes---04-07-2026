public class BulkCaseUploadController {

    @AuraEnabled
    public static string processData(String fileData,String sobjectName,List<String> fields){
        System.debug('fileData === >'+fileData);
        System.debug('fields === >'+fields);
        List<Asset> assetListToRecord = new List<Asset>();
        List<case> CaseListToRecord = new List<case>();
        map<String,String> apiNameByLabelName 	= new map<String,String>();
        Map<String,String> mapIfContEmailConId = new Map<String,String>();
        Map<String,String> mapOfProductNameProdId = new Map<String,String>();
        
        for(Contact con : [SELECT Id,Email FROM Contact]){
            if(con.Email !=null){
                mapIfContEmailConId.put(con.Email,con.Id);
            }
        }
        
        for(Product2 pro : [SELECt Id,Name FROM Product2]){
            mapOfProductNameProdId.put(pro.Name,pro.id);
        }
        
        List<Bulk_Case_Upload_Mapping__mdt> gsrCSVFileFormatList = [SELECT Case_Field_API_Name__c,Id,Label,Sequence__c FROM Bulk_Case_Upload_Mapping__mdt];
        for(Bulk_Case_Upload_Mapping__mdt gsrm : gsrCSVFileFormatList) {
            apiNameByLabelName.put(gsrm.Label,gsrm.Case_Field_API_Name__c);
        }       
        List<sObject> recordList = new List<sObject>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
        try{
            if(fileData!=null) { 
                String[] fileLines = new String[]{};
                    fileLines = fileData.split('\n');
                for (Integer i=1,j=fileLines.size();i<j;i++){
                    String[] inputvalues = new String[]{};
                        inputvalues = fileLines[i].split(',');
                    sObject obj = targetType.newSObject();
                    integer rowsize=inputvalues.size(); 
                    for(integer l=0;l<rowsize;l++){     
                        if(String.isNotBlank(inputvalues[l])) {
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                            if(value != null && apiNameByLabelName.get(fields.get(l)) !=null){
                                System.debug('value ==== >'+value);
                                System.debug('Label Name === >'+apiNameByLabelName.get(fields.get(l)));
                                if(apiNameByLabelName.get(fields.get(l)) == 'Date_Of_Order__c'){
                                    obj.put(String.valueOf(apiNameByLabelName.get(fields.get(l))),Date.valueOf(value));
                                }
                                else{
                                    obj.put(apiNameByLabelName.get(fields.get(l)),value);
                                }
                            }
                        }
                    }
                    recordList.add(obj);
                }
            }
            System.debug('recordList Size ==== >'+recordList.size());
            
            if(recordList.size()>0){
                for(sObject record : recordList){
                    Case caseRec = new case();   
                    if(record.get('Date_Of_Order__c') !=null){
                        caseRec.Date_Of_Order__c =Date.valueOf((Date)record.get('Date_Of_Order__c'));
                    }
                    if(record.get('Order__c') !=null){
                        caseRec.Order__c = (String)record.get('Order__c');
                    }
                    if(record.get('Shipping_Mobile_No__c') !=null){
                        caseRec.Shipping_Mobile_No__c	 = (String)record.get('Shipping_Mobile_No__c');
                    }
                    if(record.get('Reason') !=null){
                        caseRec.Reason	 = (String)record.get('Reason');
                    }
                    if(record.get('Item__c') !=null){
                        caseRec.Item__c	 = (String)record.get('Item__c');
                    }
                    if(record.get('OOS_Quantity__c') !=null){
                        caseRec.OOS_Quantity__c	 = (String)record.get('OOS_Quantity__c');
                    }
                    if(record.get('OOS_SKU_Code__c') !=null){
                        caseRec.OOS_SKU_Code__c	 = (String)record.get('OOS_SKU_Code__c');
                    }
                    if(record.get('Remarks_mentioned__c') !=null){
                        caseRec.Remarks_mentioned__c = (String)record.get('Remarks_mentioned__c');
                    }
                    if(record.get('Current_PIN_Code__c') !=null){
                        caseRec.Current_PIN_Code__c = (String)record.get('Current_PIN_Code__c');
                    }
                    if(record.get('City_Name__c') !=null){
                        caseRec.City_Name__c = (String)record.get('City_Name__c');
                    }
                    if(record.get('Courier_Partner__c') !=null){
                        caseRec.Courier_Partner__c = (String)record.get('Courier_Partner__c');
                    }
                    if(record.get('AWB_Number__c') !=null){
                        caseRec.AWB_Number__c = (String)record.get('AWB_Number__c');
                    }
                    if(record.get('Actual_Order_Status__c') !=null){
                        caseRec.Actual_Order_Status__c = (String)record.get('Actual_Order_Status__c');
                    }
                    
                    caseRec.Status	 = 'New';
                    caseRec.Origin	 = 'Web';
                    CaseListToRecord.add(caseRec);
                }  
                if(CaseListToRecord.size()>0){
                    insert CaseListToRecord;
                    System.debug('Case record inserted Size ==== >'+CaseListToRecord.size());
                    if(CaseListToRecord.size()>0){
                        return 'SUCCESS';
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }

    // Method for Create Bulk Case Upload using XLSX File
    @AuraEnabled 
    public static string insertBulkCaseXlsxFiel(String jsonString,String docTempName){
        System.debug('jsonString == >'+jsonString +' && docTempName  == >'+docTempName);
        try{
            List<Object> jsonData = (List<Object>) JSON.deserializeUntyped(jsonString);
            Map<String, Object> caseMap = new Map<String, Object>();
            Set<String> orderNames = new Set<String>();
            Set<String> PhoneNumbers = new Set<String>();
            List<Case> caseListToInsert = new List<Case>();
            for (Object obj : jsonData){
                Case caseRec = new Case();
                caseMap = (Map<String, Object>) obj;
                System.debug('caseMap === >'+caseMap);
                if(caseMap.get('orderno') !=null){
                    orderNames.add(String.valueOf(caseMap.get('orderno')));
                }
                if(caseMap.get('orderid') !=null){
                    orderNames.add(String.valueOf(caseMap.get('orderid')));
                }
                if(caseMap.get('phoneNumber') !=null){
                    PhoneNumbers.add(String.valueOf(caseMap.get('phoneNumber')));
                }

                if(caseMap.get('shippingmobileno') !=null){
                    caseRec.Shipping_Mobile_No__c	 = String.valueOf((Integer)caseMap.get('shippingmobileno'));
                }
                if(caseMap.get('reason') !=null){
                    caseRec.Reason	 = (String)caseMap.get('reason');
                }
                if(caseMap.get('item') !=null){
                    caseRec.Item__c	 = (String)caseMap.get('item');
                }
                if(caseMap.get('oosquantity') !=null){
                    caseRec.OOS_Quantity__c	 =String.valueOf((Integer)caseMap.get('oosquantity'));
                }
                if(caseMap.get('oosskucode') !=null){
                    caseRec.OOS_SKU_Code__c	 = (String)caseMap.get('oosskucode');
                }
                if(caseMap.get('remarks') !=null){
                    caseRec.Remarks_mentioned__c = (String)caseMap.get('remarks');
                }
                caseListToInsert.add(caseRec);
            }
            if(caseListToInsert.size()>0){
                insert caseListToInsert;
                System.debug('caseListToInsert == >'+caseListToInsert);
                return caseListToInsert.size()>0 ? 'SUCCESS' : null;
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
}