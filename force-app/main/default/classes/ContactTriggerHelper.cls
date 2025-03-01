public class ContactTriggerHelper {
    
    // Method Before Deleting Contact if Account is Present then Update Accounts phone with deleting Contact
    Public Static void BeforeDeleteContactUpdateAccountPhone(Map<Id,Contact> oldMap,Map<Id,Contact> newMap){
        System.debug('oldMap === >'+oldMap);
        List<Account> accList = new List<Account>();
        Map<String,String> AccountIdPhoneMap = new Map<String,String>();
        for(Contact con : oldMap.values()){
            if(con.AccountId !=null)
                AccountIdPhoneMap.put(con.AccountId,con.Phone);
        }
        System.debug('AccountIdPhoneMap == >'+AccountIdPhoneMap);
        if(!AccountIdPhoneMap.isEmpty()){
            for(String str : AccountIdPhoneMap.Keyset()){
                System.debug('Contact Phone === >'+AccountIdPhoneMap.get(str));
                Account acc = new Account();
                acc.Id = str;
                acc.Phone = AccountIdPhoneMap.get(str);
                accList.add(acc);
            }
            if(!accList.isEmpty()){
                update accList;
                System.debug('accList == :'+accList);
            }
        }
    }
}