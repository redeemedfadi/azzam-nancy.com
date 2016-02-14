<?php

/*
	The variables below can be overridden by setting the contact 
	form input fields as emailTo, fromName, fromEmail or subject. This can be
	useful if you want to have different contact forms in different pages and each 
	of them has different emailTo, subject, etc.
	(check the help documentation to know how to properly set up this fields).
	
	If none of the fields were set as emailTo, fromName, fromEmail
	or subject, the default values (below) will be used.
*/
$emailto = 'youremail@yourdomain.com'; 	// Insert the email address that will receive the messages
$fromName = 'Contact';					// Insert a default "Name" email address (this field will be displayed in the email header)
$fromEmail = 'default@yourdomain.com';	// Insert a default "From" email address (this field will be displayed in the email header)
$subject = 'Lilac Contact Form';		// Insert a default contact form subject



// No need to edit below this line
if(isset($_POST['emailto'])) {
	$emailto = $_POST['emailto'];
}

if(isset($_POST['fromname'])) {
	$fromName = $_POST['fromname'];
}

if(isset($_POST['fromemail'])) {
	$fromEmail = $_POST['fromemail'];
}

if(isset($_POST['subject'])) {
	$subject = $_POST['subject'];
}

$html = "";
$len = intval($_POST['len']);

if ($len){
	if (isset($_POST['fromname_label'])){
		$html .= htmlentities($_POST['fromname_label'], ENT_QUOTES, "UTF-8") . ": ";
		$html .= htmlentities($fromName, ENT_QUOTES, "UTF-8") . "<br>\n";
	}

	if (isset($_POST['fromemail_label'])){
		$html .= htmlentities($_POST['fromemail_label'], ENT_QUOTES, "UTF-8") . ": ";
		$html .= htmlentities($fromEmail, ENT_QUOTES, "UTF-8") . "<br>\n";
	}

	if (isset($_POST['subject_label'])){
		$html .= htmlentities($_POST['subject_label'], ENT_QUOTES, "UTF-8") . ": ";
		$html .= htmlentities($subject, ENT_QUOTES, "UTF-8") . "<br>\n";
	}

	for($i=0; $i<$len; $i++){
		if (isset($_POST['field'. $i .'_label']) && $_POST['field'. $i .'_value'] != ""){
			$html .= htmlentities($_POST['field'. $i .'_label'], ENT_QUOTES, "UTF-8") . ": ";
			$html .= htmlentities($_POST['field'. $i .'_value'], ENT_QUOTES, "UTF-8") . "<br>\n";
		}
	}

	$headers = "MIME-Version: 1.0\r\nContent-type: text/html; charset=utf-8\r\n";
	if ($fromName != "" || $fromEmail != ""){
		$headers .= "From: " . $fromName . "<". $fromEmail .">\r\n";
	}
	$headers .= "Reply-To: " .  $fromEmail . "\r\n";

	$html = utf8_decode($html);

	if ($html && mail($emailto, $subject, $html, $headers))
		echo 'ok';
	else
		echo 'error';
} else {
	echo 'error';
}

?>