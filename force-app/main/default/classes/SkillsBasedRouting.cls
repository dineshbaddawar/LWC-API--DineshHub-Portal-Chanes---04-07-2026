global class SkillsBasedRouting {

    @InvocableMethod
    Public static void routeUsingSkills(List<String> cases){
        List<Case> caseObjects = [SELECT Id,Description FROM Case WHERE Id IN :cases];
        
        for(Case caseObj : caseObjects){
            // Adding Skilled Based Service Routing
            PendingServiceRouting psrObj = new PendingServiceRouting(
            CapacityWeight = 1,
                IsReadyForRouting = FALSE,
                RoutingModel = 'MostAvailable',
                RoutingPriority = 1,
                RoutingType = 'SkillsBased',
                ServiceChannelId = getChannelId('Service_Channel_Name'),
                WorkItemId = caseObj.Id
            );
            insert psrObj;
            psrObj = [SELECT Id, IsReadyForRouting FROM PendingServiceRouting WHERE Id = : psrObj.id];
            
            // Now adding Skill Requirements
            SkillRequirement srObj =new SkillRequirement(
            RelatedRecordId = psrObj.Id,
            SkillId = getSkillId(caseObj.Description),
                SkillLevel = 5
                );
            insert srObj;
            
            // Updating PendingServiceRouting as IsReadyForRouting
            psrObj.IsReadyForRouting = TRUE;
            update psrObj;
        }
        return;
    }
    
    Public Static String getChannelId(String channelName){
        System.debug('Channel Name-------------'+channelName);
        ServiceChannel channel = [SELECT Id FROM ServiceChannel WHERE DeveloperName = :channelName];
           System.debug('Channel -------------'+channel);
        return channel.id;
    }
    
    public Static String getSkillId(String caseDescription){
        String skillName =  'English';
        if(caseDescription !=null){
            if(caseDescription.contains('Kanada')){
                skillName = 'kanada';
            }  else if( caseDescription.contains('Spanish')){
                skillName = 'Spanish';
            }          
        }
        
        Skill skill = [SELECT Id FROM Skill WHERE DeveloperName = : skillName];
        System.debug('skill -------------'+skill);
        return skill.id;
    }
}