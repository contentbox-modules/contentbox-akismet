component {

	// Module Properties
	this.title 				= "ContentBox Akismet";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "Helps sanitize your comments against Akismet";
	this.version			= "2.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "akismet";
	this.dependencies 		= [ "cfakismet" ];

	function configure(){

		// Compressor Settings
		settings = {
			// Api Key
			api_key = "",
			// Block if marked as spam
			block = false
		};

		// SES Routes
		routes = [
			// Module Entry Point
			{ pattern="/", handler="home", action="index" },
			// Convention Route
			{ pattern="/:handler/:action?" }
		];

		// Interceptors
		interceptors = [
			{ class="#moduleMapping#.interceptors.Akismet" }
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Do we have settings in the DB?
		var settingService = wirebox.getInstance( "SettingService@cb" );
		var args = { name="cbox-akismet" };
		var setting = settingService.findWhere( criteria=args );
		if( !isNull( setting ) ){
			// override module settings from the ones in the DB
			controller.getSetting( "modules" )[ "contentbox-akismet" ].settings = deserializeJSON( setting.getvalue() );
		}

		// Configure settings on the Library
		var oAkismet = wirebox.getInstance( "akismet@Akismet" );
		// setup API Key
		oAkismet.setAPIKey( controller.getSetting( "modules" )[ "contentbox-akismet" ].settings.api_key );
		// setup ContentBox Base URL
		var baseURL = controller.getRequestService().getContext().buildLink( controller.getSetting( "modules" )[ "contentbox-ui" ].entryPoint ); 
		oAkismet.setBlogURL( baseURL );
	}

	/**
	* Fired when the module is activated
	*/
	function onActivate(){
		var settingService = wirebox.getInstance( "SettingService@cb" );
		// store default settings
		var findArgs = { name="cbox-akismet" };
		var setting = settingService.findWhere( criteria=findArgs );
		if( isNull( setting ) ){
			var args = { name="cbox-akismet", value=serializeJSON( settings )};
			var settings = settingService.new( properties=args );
			settingService.save( settings );
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

	/**
	* Fired when the module is deactivated by ContentBox Only
	*/
	function onDeactivate(){
		var settingService = wirebox.getInstance( "SettingService@cb" );
		var args = { name="cbox-akismet" };
		var setting = settingService.findWhere( criteria=args );
		if( !isNull( setting ) ){
			settingService.delete( setting );
		}
	}
}