/**
 * @description trigger on Lead object
 * @param  insert - some leads after insert
 */
trigger LeadTrigger on SOBJECT (After insert) {
    /**
     * Invokes method to check duplicated leads after insert
     */ 
    new LeadTriggerHandler_Queueable().checkLeadAfterInsert(Trigger.New);
}