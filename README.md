Toggl-Client-Force.com
======================

### What is this?

Toggl is a nice web app that helps you keep track of where you're spending your time.

I wanted to get Toggl data into a Salesforce org, so I created this code to request data from the Toggl API.

This API was built to only request a list of time entries from Toggl, but Toggl has a much more [extensive API](https://www.toggl.com/public/api). If you'd like, you can use my code as a reference to request data from other endpoints. If you do, you should send a pull request my way.


### Manual configuration

Authorize the Toggl API endpoint
- In target org, go to Setup -> Security -> Remote site settings
- Create new Remote Site
    - Remote Site Name = 'Toggl_API'
    - Remote Site URL = 'https://www.toggl.com'


### How to Use

	// Choose a "from" day and "to" day
	Date fromDate = System.today();
    Date toDate = System.today();

    // Then wrap them into a DateTime
    DateTime fromDateToggl = DateTime.newInstance(fromDate, Time.newInstance(0, 0, 0, 0));
    DateTime toDateToggl = DateTime.newInstance(toDate, Time.newInstance(23, 59, 0, 0));

    // And pass the time window into the TogglClient.getTimeEntries
    //   method to get a typed list of Toggl time entries.
    String togglApiKey = 'your_api_key_here';
    TogglClient togglClient = new TogglClient(togglApiKey, 'api_token');
    List<TogglTimeEntry> togglTimeEntryList = togglClient.getTimeEntries(fromDateToggl, toDateToggl);


### Problems?

Three options
- Let me know by making an issue on GitHub.
- Fix it yourself and submit a pull request on GitHub.
- Find some other way to message me on the internet.


### Open Source

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
