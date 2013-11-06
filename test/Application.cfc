component{
	this.name = "Akismet Testing Suite";
	this.sessionManagement = true;

	// mappings
	this.mappings[ "/test" ] = getDirectoryFromPath( getCurrentTemplatePath() );

	rootPath = REReplaceNoCase( this.mappings[ "/test" ], "test(\\|\/)$", "" );
	this.mappings[ "/root" ] = rootPath;
	
	// request start
	public boolean function onRequestStart(String targetPage){

		return true;
	}
}