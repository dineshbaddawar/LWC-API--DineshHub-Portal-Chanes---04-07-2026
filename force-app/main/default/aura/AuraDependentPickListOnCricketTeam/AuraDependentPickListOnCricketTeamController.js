({
	doInit : function(component, event, helper) {
      //  alert("Good Morning")
      debugger;
        var cricketTeamList = [
            
            { text: "India", value:"India"},
            { text: "England", value:"England"},
            { text: "Australia", value:"Australia"}
        ];
        
        
        var TeamPlayer = {
            "India" : [
                {text : "Virat Kohali", value: "Virat Kohali"},
                {text : "KL Rahul", value: "KL Rahul"},
                {text : "Rohit Sharma(c)", value: "Rohit Sharma(c)"},
                {text : "Rishabh Pant(w)", value: "Rishabh Pant(w)"},
                {text : "Suryakumar Yadav", value: "Suryakumar Yadav"}
            ],
             "England" : [
                {text : "Alex Lees", value: "Alex Lees"},
                {text : "Zak Crawley", value: "Zak Crawley"},
                {text : "Ollie Pope", value: "Ollie Pope"},
                {text : "Joe Root", value: "Joe Root"},
                {text : "Ben Stokes (c)", value: "Ben Stokes (c)"}
            ],
            
            "Australia" : [
                {text : "Aaron Finch(c)", value: "Aaron Finch(c)"},
                {text : "David Warner", value: "David Warner"},
                {text : "Steven Smith", value: "Steven Smith"},
                {text : "Alex Carey(w)", value: "Alex Carey(w)"},
                {text : " Marcus Stoinis", value: " Marcus Stoinis"}
            ],
            
        }
              component.set("v.CricketTeam",cricketTeamList);
              component.set("v.dependentPlayer",TeamPlayer);

	},
    
    getTeamPlayer : function(component, event, helper){
        debugger;
        var getTeamPlayerName = component.find("playerId").get("v.value");
        component.set("v.temaPlayerList",component.get("v.dependentPlayer")[getTeamPlayerName]);
    },
    
})