public  class ProcessTaskRecords {
    
    public List<Task> selTaskLst;
    public String TaskIds;
    
    public ProcessTaskRecords(ApexPages.StandardSetController cntlr){
        selTaskLst = cntlr.getSelected(); //get selected records from account list view
        
        system.debug('selTaskLst :: ' + selTaskLst);
        TaskIds = '';  
        for(Task ld : selTaskLst){
            TaskIds += ld.Id + ','; //build list of ids string concatenated with comma                         
        }
        system.debug('TaskIds :: ' + TaskIds);
        TaskIds = TaskIds.removeEnd(','); 
    }
    
    public PageReference redirectToLC(){
        String returnUrl = '/lightning/cmp/c__ProcesssLeadRecordsToUsrToAssign?c__listofTasks='+TaskIds;
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    @AuraEnabled
    public static AssignUserGroupWrapper QueryAssignmentGroup(){
        AssignUserGroupWrapper AGWrap = new AssignUserGroupWrapper();
        try{
            
            Map<Id, User> AssignGroupMap = new Map<Id, User>();
            List<User> AssignGroup =[SELECT Id,Name FROM User];
            
            for(User AG : AssignGroup){
                AssignGroupMap.put(AG.id, AG);
            }
            AGWrap.AssignGroupMapWrap = AssignGroupMap;
            ListView listviews =[SELECT Id, Name FROM ListView WHERE SobjectType = 'Task' and name = 'All Tasks'];
            System.debug('listviews ::'+listviews);
            AGWrap.AllTasklistview = listviews;
            system.debug('AGWrap :: ' + AGWrap);
            return AGWrap;
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage() + ' at lin number :: ' + e.getLineNumber());
        }
        return AGWrap;
    }
    
     @AuraEnabled
    public static String TransferTask(List<String> TaskListId, String SelectedAssignUserGroup){
        try{
            if(!TaskListId.isEmpty()){
                List<Task> taskListTobeUpdate = [select id,OwnerId from task where id in: TaskListId];
                for(Task ts : taskListTobeUpdate){
                    ts.ownerId = SelectedAssignUserGroup;
                }
                update taskListTobeUpdate;
            }
        }catch(Exception e){
            system.debug('Exception::'+e.getStackTraceString());
            return e.getStackTraceString();
        }
        return 'SUCCESS';
    }
    
      public class AssignUserGroupWrapper{
        
        @AuraEnabled
        public Map<Id, User> AssignGroupMapWrap {get; set;}
        @AuraEnabled
        public ListView AllTasklistview {get; set;}
        
    }
    
    /*
     CMP:

<aura:component   implements="lightning:isUrlAddressable,force:appHostable,flexipage:availableForAllPageTypes,flexipage:availableForRecordHome,force:hasRecordId,force:lightningQuickAction"
    access="global" controller="ProcessTaskRecords"> 
     <!--style to incraee width-->
    <aura:html tag="style">
        .slds-modal__container{
        max-width: 80rem !important;
        width:80% !important;
        }
    </aura:html>

    <aura:attribute name="ListofTasks" type="List" />
    <aura:handler name="init" value="{!this}" action="{!c.onPageReferenceChange}" />
    <aura:handler name="change" value="{!v.pageReference}" action="{!c.onPageReferenceChange}" />
    <aura:attribute name="isModalOpen" type="boolean" default="false" />
    <aura:attribute name="AssignGroupList" type="List" />
    <aura:attribute name="SelectedAssignGroup" type="String" /> 
    <aura:attribute name="AllTaskListview" type="Object" />


    <aura:if isTrue="{!v.isModalOpen}">

        <!-- Modal/Popup Box starts here-->
        <section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
            aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
            <div class="slds-modal__container">
                <!-- Modal/Popup Box Header Starts here-->
                <header class="slds-modal__header">
                    <lightning:buttonIcon iconName="utility:close" onclick="{! c.closeModel }" alternativeText="close"
                        variant="bare-inverse" class="slds-modal__close" />
                    <h2 id="modal-heading-01" class="slds-text-heading_medium slds-hyphenate">Modal/PopUp Box</h2>
                </header>
                <!--Modal/Popup Box Body Starts here-->
                <div class="slds-modal__content slds-p-around_medium" id="modal-content-id-1">

                    <lightning:card title="Task List">
                        <!-- aura:iteration items="{!v.ListofTasks}" var="item">
                            <p class="slds-p-horizontal_small"> Lead Id {!item} </p>
                        </aura:iteration -->

                        <lightning:select name="Assignment Groups" label="" required = "true" value="{!v.SelectedAssignGroup}" >
                                <option value="">choose one...</option>
                                <aura:iteration items="{!v.AssignGroupList}" var="item">
                                    <option text="{!item.value}" value="{!item.key}" />
                                </aura:iteration>
                            </lightning:select>
                    </lightning:card>
                </div>
                <!--Modal/Popup Box Footer Starts here-->
                <footer class="slds-modal__footer">
                    <lightning:button variant="neutral" label="Cancel" title="Cancel" onclick="{! c.closeModel }" />
                    <lightning:button variant="brand" label="OK" title="OK" onclick="{!c.submitDetails}" />
                </footer>
            </div>
        </section>
        <div class="slds-backdrop slds-backdrop_open"></div>
        </aura:if>
	
</aura:component>


CONT:

({
    onPageReferenceChange: function (cmp, evt, helper) {
        debugger;
        var myPageRef = cmp.get("v.pageReference");
        var Tasks = myPageRef.state.c__listofTasks;
        console.log('listofAccounts', JSON.stringify(Tasks));

        var TasksArr = Tasks.split(',');
        cmp.set("v.ListofTasks", TasksArr);
        //var AssignmentGroupList = [];
        helper.GetAssignmentgroup(cmp, evt);
        cmp.set("v.isModalOpen", true);
        //split the account ids by comma and continue logic
    },
    closeModel: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
        var TaskListView = component.get("v.AllTaskListview");
        component.set("v.isModalOpen", false);
        var navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            "listViewId": TaskListView.Id,
            "listViewName": TaskListView.Name,
            "scope": "Lead"
        });
        navEvent.fire();
    },

    submitDetails: function (component, event, helper) {
        debugger;
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        var selectedAssignGroupForJs = component.get("v.SelectedAssignGroup");
        var leadlist = component.get("v.ListofTasks");

        var action = component.get('c.TransferTask');
        action.setParams({
            TaskListId: leadlist,
            SelectedAssignUserGroup: selectedAssignGroupForJs
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                var serverResponse = response.getReturnValue();

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Success',
                    message: 'Task has been Assigned to Selected User successFully!!!!!',
                    duration: ' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();

                var TaskListView = component.get("v.AllTaskListview");
                component.set("v.isModalOpen", false);
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": TaskListView.Id,
                    "listViewName": TaskListView.Name,
                    "scope": "Task"
                });
                navEvent.fire();
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})
*/
/*
JS:

({
	GetAssignmentgroup: function (cmp, evt) {
		debugger;
		// create a one-time use instance of the serverEcho action
		// in the server-side controller
		var action = cmp.get('c.QueryAssignmentGroup');
		

		// Create a callback that is executed after 
		// the server-side action returns
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				// Alert the user with the value returned 
				// from the server
				var serverResponse = response.getReturnValue();
				var AssignGroupmap = [];
				for(var key in serverResponse.AssignGroupMapWrap){
                    AssignGroupmap.push({key: key, value: serverResponse.AssignGroupMapWrap[key].Name});
                    
                }

				cmp.set("v.AssignGroupList", AssignGroupmap);
				cmp.set("v.AllTaskListview", serverResponse.AllTasklistview);


				// You would typically fire a event here to trigger 
				// client-side notification that the server-side 
				// action is complete
			}
			else if (state === "INCOMPLETE") {
				// do something
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " +
							errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
			//var dismissActionPanel = $A.get("e.force:closeQuickAction");
			//dismissActionPanel.fire();
		});

		// optionally set storable, abortable, background flag here
		// A client-side action could cause multiple events, 
		// which could trigger other events and 
		// other server-side action calls.
		// $A.enqueueAction adds the server-side action to the queue.
		$A.enqueueAction(action);
	},
	
})
*/
/*
VF:

<apex:page standardController="Task" recordSetVar="Task" extensions="ProcessTaskRecords" action="{!redirectToLC}"/>


     */
}