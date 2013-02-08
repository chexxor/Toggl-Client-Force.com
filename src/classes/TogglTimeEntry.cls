public with sharing class TogglTimeEntry {

	//Custom Properties - for convenience.
	public DateTime startWithoutTimezone {
		get {
			DateTime startGmt = this.start;
			if (startGmt == null)
				return null;
			/*
			TimeZone userTimezone = UserInfo.getTimeZone();
			Integer offsetFromGmtInMs = userTimezone.getOffset(startGmt);
			Integer offsetFromGmtInHr = offsetFromGmtInMs / 1000 / 3600;
			*/
			//TODO: Change this to the above once prod is the Spring 13 release.
			Integer offsetFromGmtInHr = -6;
			DateTime startLocal = startGmt.addHours(offsetFromGmtInHr);
			return startLocal;
		}
	}
	public Boolean isLogged {get; set;}

	//JSON Properties - these must not change names.
	public DateTime start {get; set;}
	public DateTime stop {get; set;}
	public Integer duration {get; set;}
	public String id {get; set;}
	public TogglProject project {get; set;}
	public List<String> tagNamesList {get; set;}
	public String description {get; set;}
	public Boolean ignoreStartStop {get; set;}
	
	
	public TogglTimeEntry() { }
	
	public class TogglProject {
		
		public String clientName {
			get {
				String clientName = '';
				if (this.client_project_name == null || this.client_project_name == '') {
					return '';
				}
				else {
					clientName = this.client_project_name.substring(0, this.client_project_name.indexOf(' -'));
				}
				return clientName;
			}
		}
		
		//JSON Properties - these must not change names.
		public String name {get; set;}
		public String id {get; set;}
		public String client_project_name {get; set;}
	}

}