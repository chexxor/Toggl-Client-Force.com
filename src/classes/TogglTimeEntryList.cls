public with sharing class TogglTimeEntryList {
	
	//Custom properties - convenient views onto data.
	public List<TogglTimeEntry> timeEntryList {get; set;}
	
	//JSON Properties - these must not change names.
	public List<TogglTimeEntry> data {
		get { return this.timeEntryList; }
		set { this.timeEntryList = value; }
	}

	public TogglTimeEntryList() { }

}