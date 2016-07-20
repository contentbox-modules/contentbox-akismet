<cfoutput>
<!--- Notifications --->
<div class="tab-pane" id="akismet">
	<fieldset>
	<legend><i class="icon-cloud icon-large"></i> <strong>Akismet</strong></legend>
		<p>
			From here you can configure the ContentBox Akismet module.  First, you will need to have a valid Akismet account API key. If you
			do not have one, please go to <a href="http://www.akismet.com" target="_blank">www.akismet.com</a> and register for one. Then you must also make sure <strong>Comment Moderation</strong> is enabled in the <strong>Moderation</strong> tab in order for the Akismet rules to fire.
		</p>

		<div class="control-group" id="akismetControlGroup">
			
			<label class="control-label" for="akismet_apikey">Akismet API Key:</label>
			<div class="input-append">
				<!--- API Key --->
				#html.textField(name="akismet_apikey", size="50", value=prc.akismet_settings.api_key)#
				<!--- Verify --->
				<button id="btnVerifyAkismet" class="btn btn-info btn-sm" onclick="return verifyAkismet()">Verify Key</button>
			</div>
		</div>

		<!--- Block Comments  --->
		<div class="control-group">
			#html.label(field="akismet_block",content="Block Comments If Spam:",class="control-label")#
			<small>If the comment is spam and this setting is true, the comment will NOT be saved but ignored.</small>
			<div class="controls">
				#html.radioButton(name="akismet_block",checked=prc.akismet_settings.block,value=true)# Yes 	
				#html.radioButton(name="akismet_block",checked=not prc.akismet_settings.block,value=false)# No   
			</div>
		</div>

	</fieldset>						
</div>
<script type="text/javascript">
$(document).ready(function() {
});
function verifyAkismet(){
	$("##btnVerifyAkismet").html( '<i class="fa fa-spin fa-spinner"></i> Verifying...' );
	// post it
	$.post( '#prc.xehVerifyAkismet#', { apikey : $("##akismet_apikey").val() }, function(data){
		$("##akismetControlGroup").removeClass().addClass( "control-group" );
		if( data.ERROR ){
			adminNotifier( 'error', data.MESSAGES );
		}
		else if( data.VALIDATED ){
			$("##akismetControlGroup").addClass( "success" );
			adminNotifier( 'success', 'Key Verified Successfully!', 2000 );
		}
		else{
			$("##akismetControlGroup").addClass( "warning" );
			adminNotifier( 'warning', 'The key is not a valid Akismet Key!', 3000 );	
		}
		$("##btnVerifyAkismet").html( 'Verify Key' );
	}, "JSON");
	return false;
}
</script>
</cfoutput>
