public with sharing class CtlrTogglDemo {

    public Boolean isTogglUser {get; set;}
    public List<TogglTimeEntry> togglTimeEntryList {get; set;}
    
    //Demo date-picker fields
    public Opportunity fromDate{get; set;}
    public Opportunity toDate {get; set;}

    public CtlrTogglDemo() {
    
        this.fromDate = new Opportunity(CloseDate = System.today());
        this.toDate = new Opportunity(CloseDate = System.today());
        
        this.updateTimeEntries();
        
    }
    
    public PageReference updateTimeEntries() {
    
        String togglApiKey = null;
        TogglClient togglClient = null;
        
        try {
            togglApiKey = [SELECT Toggl_Api_Key__c FROM User WHERE Id = :UserInfo.getUserId()].Toggl_Api_Key__c;
        }
        catch (System.QueryException e) {
            System.debug('QueryException: ' + e.getMessage());
        }
        this.isTogglUser = (togglApiKey != null && togglApiKey != '');
        if (this.isTogglUser) {
            togglClient = new TogglClient(togglApiKey, 'api_token');
            //Date fromDate = System.today();
            //Date toDate = System.today();
            Date fromDate = this.fromDate.CloseDate;
            Date toDate = this.toDate.CloseDate;
            DateTime fromDateToggl = DateTime.newInstance(fromDate, Time.newInstance(0, 0, 0, 0));
            DateTime toDateToggl = DateTime.newInstance(toDate, Time.newInstance(23, 59, 0, 0));
            try {
                this.togglTimeEntryList = togglClient.getTimeEntries(fromDateToggl, toDateToggl);
            }
            catch (System.CalloutException e) {
                System.debug('Toggl CalloutException: ' + e.getMessage());
                this.togglTimeEntryList = new List<TogglTimeEntry>();
                TogglTimeEntry messageEntry = new TogglTimeEntry();
                messageEntry.description = 'CalloutException - Message: ' + e.getMessage() + ' StackTrace: ' + e.getStackTraceString();
                this.togglTimeEntryList.add(messageEntry);
            }
            catch (System.JSONException e) {
                System.debug('e: ' + e);
                this.togglTimeEntryList = new List<TogglTimeEntry>();
                TogglTimeEntry messageEntry = new TogglTimeEntry();
                messageEntry.description = 'JSONException - Message: ' + e.getMessage() + ' StackTrace: ' + e.getStackTraceString();
                this.togglTimeEntryList.add(messageEntry);
            }
            catch (System.Exception e) {
                System.debug('e: ' + e);
                this.togglTimeEntryList = new List<TogglTimeEntry>();
                TogglTimeEntry messageEntry = new TogglTimeEntry();
                messageEntry.description = e.getTypeName() + ' Exception - Message: ' + e.getMessage() + ' StackTrace: ' + e.getStackTraceString();
                this.togglTimeEntryList.add(messageEntry);
            }
        }
        
        return null;
    }

}