<!DOCTYPE html>
<html>
	<head>
		<meta http -equiv="Content-Type" content="text/html; charset=utf-8" />

		<base id="base_url" href="<?=base_url(); ?>" />
		<!-- Screen -->
		<link rel="StyleSheet" href="<?=base_url(); ?>include/css/clear.css" type="text/css" />
		<link rel="StyleSheet" href="<?=base_url(); ?>include/css/screen.css" type="text/css" />

		<!-- Mobile -->
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=2.0, user-scalable=yes" />

		<!--<link rel="stylesheet" type="text/css" media="only screen and (max-width: 570px), only screen and (max-device-width: 570px)" href="<?=base_url(); ?>include/css/antiscreen.css" />
		<link rel="stylesheet" type="text/css" media="handheld, only screen and (max-width: 570px), only screen and (max-device-width: 570px)" href="<?=base_url(); ?>include/css/clear.css" />-->
		<link rel="stylesheet" type="text/css" media="handheld, only screen and (max-width: 570px), only screen and (max-device-width: 570px)" href="<?=base_url(); ?>include/css/handheld.css" />
		<!--[if IEMobile]>
			<link rel="stylesheet" type="text/css" media="screen" href="<?=base_url(); ?>include/css/handheld.css" />
		<![endif]-->
		
	<!--  Jquery UI Style -->
	<link rel="StyleSheet" href="<?=base_url(); ?>include/css/ui-lightness/jquery-ui-1.8.21.custom.css" type="text/css" />
		
		
		<title>
			<?php if (!empty($title)){
				echo $title;
				echo " - ";
			}?>
			The Edge RFID Checkin
		</title>

		<script type="text/javascript" src="<?=base_url(); ?>include/js/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="<?=base_url(); ?>include/js/jquery-ui-1.8.21.custom.min.js"></script>
		<script type="text/javascript" src="<?=base_url(); ?>include/js/rfid_edge_common.js"></script>
	</head>
		<body>
			<div class="feedback-div">
				<?php echo anchor('edge_user/feedback', 'Let us know what you think!<br />Send us your Feedback', array('class'=>'feedback-message', 'title'=>'Send Us Your Feedback')); ?>
			</div>

			<a id="logo" class="center" href="http://edgeqld.org.au"><h1>The Edge RFID Checkin</h1></a>
			