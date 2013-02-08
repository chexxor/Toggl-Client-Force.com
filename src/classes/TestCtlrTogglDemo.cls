@isTest
private class TestCtlrTogglDemo {
    
    static testMethod void test_Init() {
        //Create test data
        
        //Invoke functionality
        Test.startTest();
            CtlrTogglDemo ctlr = new CtlrTogglDemo();
        Test.stopTest();
        
        //Check results
        System.assertEquals(true, ctlr != null);
    }
    
}