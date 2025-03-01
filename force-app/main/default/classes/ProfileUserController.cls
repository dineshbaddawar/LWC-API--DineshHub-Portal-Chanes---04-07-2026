public with sharing class ProfileUserController {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, List<User>> getProfileUserMap() {
        Map<String, List<User>> profileUserMap = new Map<String, List<User>>();
        List<User> userList = [SELECT Id, Name, Profile.Name FROM User];
        System.debug('userList == >'+userList);
        
        for(User u : userList) {
            String profileName = u.Profile.Name;
            if(profileName !=null){
                if(!profileUserMap.containsKey(profileName)) {
                    profileUserMap.put(profileName, new List<User>());
                }
                profileUserMap.get(profileName).add(u);
            }
        }
        System.debug('profileUserMap == >'+profileUserMap);
        System.debug('profileUserMap Key == >'+profileUserMap.keySet());
        System.debug('profileUserMap Value == >'+profileUserMap.Values());
        return profileUserMap;
    }
    
     @AuraEnabled(cacheable=true)
    Public static Map<String, List<SObject>> getDyanamicParentChildRecord(String childObject,string childParnetName){
        System.debug('childObject == >'+childObject+' && childParnetName == >'+childParnetName);
        try{
           // if(parentObject =='Account' && childObject == 'Contact'){
                Map<String, List<SObject>> parentChildMap = new Map<String, List<SObject>>();
                String Query = 'SELECT Id,Name, '+childParnetName+' FROM '+childObject;
                System.debug('Query == >'+Query);
                List<SObject> SobjectList = Database.query(Query);
                for(SObject obj : SobjectList) {
                    String parentName = childParnetName;
                    if(parentName !=null){
                        if(!parentChildMap.containsKey(parentName)) {
                            parentChildMap.put(parentName, new List<SObject>());
                        }
                        parentChildMap.get(parentName).add(obj);
                    }
                }
                System.debug('parentChildMap == >'+parentChildMap);
                System.debug('parentChildMap Key == >'+parentChildMap.keySet());
                System.debug('parentChildMap Value == >'+parentChildMap.Values());
                return parentChildMap;
          //  }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    } 
    
}