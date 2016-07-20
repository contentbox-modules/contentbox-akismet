component{

	// DI
	property name="settingService" 	inject="settingService@cb";
	property name="cb" 				inject="cbHelper@cb";
	property name="akismet" 		inject="akismet@akismet";

	// verify api key
	function verifyKey(event,rc,prc){
		event.paramValue( "apiKey", "" );
		var results = { "ERROR" = false, "MESSAGES" = "", "VALIDATED" = false };

		results.validated = akismet.verifyKey( rc.apikey );

		event.renderData( type="json", data=results );
	}

}