/**
********************************************************************************
Copyright 2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************
@author Luis Majano
Askismet interface www.akismet.com
Developer API http://akismet.com/development/api/
Based on CFAkismet by Brandon Harper

**/
component{

	// DI
	property name="cb" 				inject="cbHelper@cb";
	
	// listen on the comment navigation
	function cbadmin_onCommentSettingsNav( event, interceptData, buffer ){
		savecontent variable="local.tab"{
			writeOutput('
				<li><a href="##akismet" data-toggle="tab"><i class="icon-cloud icon-large"></i> Akismet</a></li>
			');
		}

		buffer.append( local.tab );
	}

	// listen on the comment tab
	function cbadmin_onCommentSettingsContent( event, interceptData, buffer ){
		var prc = event.getCollection( private=true );
		// deserialize settings
		prc.akismet_settings = deserializeJSON( prc.cbSettings[ "cbox-akismet" ] );
		prc.xehVerifyAkismet = cb.buildModuleLink( "akismet", "home.verifyKey");
		
		// Append Tab
		buffer.append( renderView( view="settingsTab", module="contentbox-akismet" ) );
	}

	// listen to comment settings save
	function cbadmin_preCommentSettingsSave( event, interceptData, buffer ){
		var rc = event.getCollection();
		// build up json packet for settings
		rc[ "cbox-akismet" ] = serializeJSON({
			"api_key" = rc.akismet_apikey
		});
		// remove non setting
		structDelete( rc, "akismet_apikey" );
	}

}