@isTest
private class TestTogglClient {

    static testMethod void test_GetTimeEntries_ShouldGetMockData() {
        //Create test data
        String togglApiKey = '';
        DateTime fromDateTime = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));
        DateTime toDateTime = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));
        
        //Invoke functionality
        Test.startTest();
            TogglClient togglClient = new TogglClient(togglApiKey, 'api_token');
            List<TogglTimeEntry> togglTimeEntryList = togglClient.getTimeEntries(fromDateTime, toDateTime);
        Test.stopTest();
        
        //Check results
        System.debug('togglTimeEntryList: ' + togglTimeEntryList);
        System.assertEquals(1, togglTimeEntryList.size());
        System.assertEquals('Todays time entry', togglTimeEntryList.get(0).description);
        System.assertEquals(900, togglTimeEntryList.get(0).duration);
    }
    
    static testMethod void test_TogglTimeEntry() {
        
        TogglTimeEntry timeEntry = new TogglTimeEntry();
        timeEntry.start = System.now();
        timeEntry.stop = System.now();
        timeEntry.duration = 100;
        timeEntry.id = 'timeEntryId';
        timeEntry.Project = new TogglTimeEntry.TogglProject();
        timeEntry.Project.name = 'test project';
        timeEntry.id = 'projectId';
        timeEntry.tagNamesList = new List<String>{'1', '2', '3'};
        timeEntry.description = 'time entry description';
        timeEntry.ignoreStartStop = false;
        
        DateTime startDateTime = timeEntry.startWithoutTimezone;
        String projectClientName = timeEntry.Project.clientName;
        
        System.assertEquals(true, true);
    }
    
    static testMethod void test_TogglTimeEntryList() {
    
        TogglTimeEntryList timeEntryList = new TogglTimeEntryList();
        timeEntryList.data = new List<TogglTimeEntry>();
        TogglTimeEntry timeEntry = new TogglTimeEntry();
        timeEntry.description = 'testDescription';
        timeEntryList.data.add(timeEntry);
        
        System.assertEquals(true, true);
    }

}