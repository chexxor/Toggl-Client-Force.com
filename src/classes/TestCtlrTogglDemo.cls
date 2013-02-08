@isTest
private class TestCtlrTogglDemo {
    
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
    
}