public with sharing class TogglClient {
    public static final String DATE_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss';
    public static final String DATA = 'data';
    private final static String TIME_ENTRIES_ENDPOINT = 'https://www.toggl.com/api/v6/time_entries.json';
    private final static String ME_ENDPOINT = 'https://www.toggl.com/api/v6/me.json';
    
    public static HttpResponse mockTogglResponse = null;

    private String user {get; set;}
    private String password {get; set;}

    //Constructor to create an instance of Toggl
    // @param user username or api_token
    // @param password password or string 'api_token'
    public TogglClient(String user, String password) {
        this.user = user;
        this.password = password;
    }
    
    public List<TogglTimeEntry> getTimeEntries() {
        return this.getTimeEntries(null, null);
    }
    
    /*
    Expected Response:
    
    {
          "data": [
              {
                  "duration": 900,
                  "billable": true,
                  "workspace": {
                      "name": "john.doe@gmail.com's workspace",
                      "id": 31366
                  },
                  "stop": "2010-02-12T15:51:19+02:00",
                  "id": 2913477,
                  "project": {
                      "name": "Important project",
                      "id": 189657,
                      "client_project_name": "Important project"
                  },
                  "start": "2010-02-12T15:35:47+02:00",
                  "tag_names": [
                      "API"
                  ],
                  "description": "Todays time entry",
                  "ignore_start_and_stop": false
              }
          ],
          "related_data_updated_at": "2010-06-29T11:17:19+03:00"
    }
    */
    public List<TogglTimeEntry> getTimeEntries(DateTime startDate, DateTime endDate) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        
        System.debug('startDate: ' + TogglClient.convertDateToString(startDate));
        System.debug('endDate: ' + TogglClient.convertDateToString(endDate));
        /*//I wonder why headers don't work...
        if (startDate != null && endDate != null) {
            req.setHeader('start_date', TogglClient.convertDateToString(startDate));
            req.setHeader('end_date', TogglClient.convertDateToString(endDate));
        }
        */
        String authHeader = TogglClient.buildAuthHeader(this.user, this.password);
        req.setHeader('Authorization', authHeader);
        
        String endpointWithQuery = TogglClient.appendQuery(TogglClient.TIME_ENTRIES_ENDPOINT, startDate, endDate);
        req.setEndpoint(endpointWithQuery);
        System.debug('req: ' + req);
        
        //Make callout.
        Http http = new Http();
        HttpResponse res = null;
        if (Test.isRunningTest()) {
            HttpResponse mockResponse = null;
            if (TogglClient.mockTogglResponse != null)
                mockResponse = TogglClient.mockTogglResponse;
            else {
                mockResponse = TogglClient.createMockTogglTimeEntriesResponse();
            }
            res = mockResponse;
        }
        else {
            try {
                res = http.send(req);
            }
            catch (Exception e) {
                res = new HttpResponse();
                res.setBody (e.getMessage());
                res.setStatus('ERROR');
                res.setStatusCode(405);
            }
        }
        
        String resBody = res.getBody();
        System.debug('resBody: ' + resBody);
        
        if (resBody.startsWith('Unauthorized endpoint')) {
            throw new TogglClientException(resBody);
        }
        
        //Turn the response into a JSON object.
        //TogglTimeEntryList togglTimeEntryList = (TogglTimeEntryList)JSON.deserializeStrict(resBody, Type.forName('TogglTimeEntryList'));
        TogglTimeEntryList togglTimeEntryList = (TogglTimeEntryList)JSON.deserialize(resBody, Type.forName('TogglTimeEntryList'));
        System.debug('togglTimeEntryList: ' + togglTimeEntryList);

        return togglTimeEntryList.timeEntryList;

    }

    public static String buildAuthHeader(String username, String password) {
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String base64Credentials = EncodingUtil.base64Encode(headerValue);
        String authHeader = 'Basic ' + base64Credentials;
        return authHeader;
    }
    
    public static String appendQuery(String endpoint, DateTime startDate, DateTime endDate) {
        String endpointWithQuery = endpoint;
        if (startDate != null && endDate != null)
            endpointWithQuery 
                += '?start_date=' + TogglClient.convertDateToString(startDate)
                + '&end_date=' + TogglClient.convertDateToString(endDate);
        return endpointWithQuery;
    }

    public static DateTime convertStringToDate(String dateString) {
        DateTime dateT = DateTime.parse(dateString);
        return dateT;
    }
    
    public static String convertDateToString(DateTime dateT) {
        /*
        TimeZone userTimezone = UserInfo.getTimeZone();
        Integer offsetFromGmtInMs = userTimezone.getOffset(dateT);
        Integer offsetFromGmtInHr = offsetFromGmtInMs / 1000 / 3600;
        */
        //TODO: Change this to the above once prod is the Spring 13 release.
        Integer offsetFromGmtInHr = -6;
        String offsetFromGmtInHrFormatted = String.valueOf(offsetFromGmtInHr) + ':00';
        System.debug('offsetFromGmtInHrFormatted: ' + offsetFromGmtInHrFormatted);
        System.debug('offsetFromGmtInHrFormatted.length(): ' + offsetFromGmtInHrFormatted.length());
        if (offsetFromGmtInHrFormatted.length() == 5) {
            offsetFromGmtInHrFormatted = offsetFromGmtInHrFormatted.replace('-', '-0');
            offsetFromGmtInHrFormatted = offsetFromGmtInHrFormatted.replace('+', '+0');
        }
        return dateT.format(TogglClient.DATE_FORMAT) + offsetFromGmtInHrFormatted;
        //return dateT.format(TogglClient.DATE_FORMAT);
    }
    
    public static HttpResponse createMockTogglTimeEntriesResponse() {
        HttpResponse mockRes = new HttpResponse();
        mockRes.setStatus('OK');
        mockRes.setStatusCode(200);
        String mockTogglResponseBody = '{"data": [{"duration": 900,"billable": true,"workspace": {"name": "john.doe@gmail.com\'s workspace","id": 31366},"stop": "2010-02-12T15:51:19+02:00","id": 2913477,"project": {"name": "Important project","id": 189657,"client_project_name": "Important project"},"start": "2010-02-12T15:35:47+02:00","tag_names": ["API"],"description": "Todays time entry","ignore_start_and_stop": false}],"related_data_updated_at": "2010-06-29T11:17:19+03:00"}';
        mockRes.setBody(mockTogglResponseBody);
        return mockRes;
    }
    
    public class TogglClientException extends Exception {}
}