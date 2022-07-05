public with sharing class LeadTriggerHandler_Queueable {
    private List<Lead> duplicatedLeads;
    
    /**
     * @description constructor 
     */ 
    public LeadTriggerHandler_Queueable() {
    }
    
    /**
     * @description constructor with leads 
     * @param duplicatedLeads duplicated leads to delete
     */ 
    public LeadTriggerHandler_Queueable(List<Lead> duplicatedLeads) {
        this.duplicatedLeads = duplicatedLeads;
    }
    
    /**
     * @description delete duplicated leads
     * @param  context 
     */
    public void execute(QueueableContext context){
    	delete duplicatedLeads;
    }    

    /**
     * @description method to check duplicated leads after insert
     * @param  leads list of leads from trigger
     */ 
    public void checkLeadAfterInsert(List<Lead> leads){
        List<Lead> leadsToDelete = new List<Lead>();
        Set<String> setCompany = new Set<String>();
        Set<Id> setIds = new Set<Id>();
        for(Lead lead : leads)
        {
            setCompany.add(lead.Company);
            setIds.add(lead.Id);
        }
        
        if(setCompany.size() > 0 )
        {
            for(Lead oldLead : [SELECT Company, Email, id  FROM Lead WHERE Company in :setCompany AND id NOT IN :setIds]){
            	for(Lead newLead : leads){
                	if(oldLead.Company.equals(newLead.Company) && oldLead.Email != null && newLead.Email != null){
                        if(newLead.Email.equals(oldLead.Email)){
							leadsToDelete.add(newLead);
                    	}
                    }
                }
            }  
        }
        
        if(leadsToDelete.size() > 0){
            System.enqueueJob(new LeadTriggerHandler_Queueable(leadsToDelete)); 
            
        }
    }
}
