jQuery(document).ready(function($) {
  $('a[rel*=facebox]').facebox({
		opacity : 0.5
	}) 
});

function count(maxLength) {

	var lngCount = $("#facebox #post_text").val().length;
	
	currentLength = maxLength - lngCount;
	
	if (lngCount > maxLength) {
		$("#facebox #count").html("<span style='color:red;'>" + currentLength + "</span>");
		$('#facebox #post_submit').attr('disabled', 'disabled');
	} else {
		$("#facebox #count").html(currentLength);
		$('#facebox #post_submit').removeAttr('disabled');
	}
	
}