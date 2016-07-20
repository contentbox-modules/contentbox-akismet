component{

	// DI
	property name="cb" 				inject="cbHelper@cb";
	property name="akismet" 		inject="provider:akismet@akismet";
	property name="coldbox"			inject="coldbox";

	// listen on the comment navigation
	function cbadmin_onCommentSettingsNav( event, interceptData, buffer ){
		savecontent variable="local.tab"{
			writeOutput('
				<li><a href="##akismet" data-toggle="tab"><i class="fa fa-cloud"></i> Akismet</a></li>
			');
		}

		buffer.append( local.tab );
	}

	// listen on the comment tab
	function cbadmin_onCommentSettingsContent( event, interceptData, buffer ){
		var prc = event.getCollection( private=true );
		
		// prepare settings and links
		prc.akismet_settings = coldbox.getSetting( "modules" )[ "contentbox-akismet" ].settings;
		prc.xehVerifyAkismet = cb.buildModuleLink( "akismet", "home.verifyKey");
		
		// Append Tab
		buffer.append( renderView( view="settingsTab", module="contentbox-akismet" ) );
	}

	// listen to comment settings save
	function cbadmin_preCommentSettingsSave( event, interceptData, buffer ){
		var rc = event.getCollection();
		// build up json packet for settings
		rc[ "cbox-akismet" ] = serializeJSON({
			"api_key" 	= rc.akismet_apikey,
			"block" 	= rc.akismet_block
		});
		// Update settings in memory
		coldbox.getSetting( "modules" )[ "contentbox-akismet" ].settings = {
			api_key = rc.akismet_apikey,
			block   = rc.akismet_block
		};
		// remove non setting
		structDelete( rc, "akismet_apikey" );
		structDelete( rc, "akismet_block" );
	}

	// listen to when comments are about to be moderated
	function cbui_onCommentModerationRules( event, interceptData, buffer ){
		var oComment = arguments.interceptData.comment;
		var settings = coldbox.getSetting( "modules" )[ "contentbox-akismet" ].settings;
		
		// check if key is empty? If it is, just return
		if( !len( settings.api_key ) ){
			return;
		}		

		// verify if spam?
		var isSpam = akismet.isCommentSpam(
			author = oComment.getAuthor(),
			authorURL = oComment.getAuthorURL(),
			authorEmail = oComment.getAuthorEmail(),
			content = oComment.getContent(),
			permalink = cb.linkContent( oComment.getRelatedContent() )
		);

		// if block is setup and comment is spam, then ignore.
		if( settings.block and isSpam ){
			oComment.setIsApproved( false );
			arguments.interceptData.allowSave = false;
			log.info( "Incoming comment is spam and block enabled, ignoring comment.", oComment.getMemento() );
		}
		// else, if spam, mark it
		else if( !settings.block AND isSpam ){
			oComment.setIsApproved( false );
			log.info( "Incoming comment is spam so moderating it.", oComment.getMemento() );
		}

	}

}