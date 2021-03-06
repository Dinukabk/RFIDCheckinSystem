<?php
	print '<div id="content" class="center">';
	print '<div class="content-inner center">';

	if($is_admin) {
		print anchor('admin','Return To Admin', array('class'=>'logg-button','title'=>'Return To Admin', 'style'=>'float:right'));
	}
	print anchor('edge_user/profile','Return To Your Profile', array('class'=>'logg-button','title'=>'Return To Your Profile', 'style'=>'float:right'));
	print '<br/>';
	print '<fieldset style="clear:both">';
	print '<legend>Project Listings</legend>';	
	print '<div id="tableContainer" class="tableContainer">';
	print '<table class="scrollTable" cellspacing="0" cellpadding="0" border="0" width="100%">';
	//print '<table cellspacing="3px" cellpadding="0" width="100%">';
	print '<thead class="fixedHeader">';
	//print '<thead>';
	print'<th style="width:30%">Name</th>';
	print '<th>Description</th>';
	print '<th></th>';
	print '</thead>';	
	print '<tbody class="scrollContent">';
	foreach ($project_list as $key=>$value) {
		print '<tr >';
		print '<td valign="middle">';
		print $value['Name'];
		print '</td>';
		print '<td valign="middle">';
		print $value['Description'];
		print '</td>';
		print '<td valign="top">';
		print anchor('project/profile/' . $value['ID'], 'EDIT',array('class'=>'logg-button','title'=>'Modify Project Details or Delete Project'));
		print '</td>';
		print '</tr>';
	}
	print '</tbody>'	;
	
	print '</table>';
	print '</div>';	// Scrollable Table
	print '<div class="center">';
	print '<hr/>';
	print anchor('project/create','Create Project', array('class'=>'logg-button','title'=>'Create A New Project'));
	print '</div>';
	print '<hr />';

	print '</fieldset>';
	print '</div>';
	print '</div>';
?>
