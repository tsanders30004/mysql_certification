<html>
<body style="font-family:sans-serif">

<style>
table {
    border-collapse: collapse;
    width: 100%;
}

th, td {
    text-align: left;
    padding: 8px;
}

tr:nth-child(even) {background-color: #f2f2f2;}
</style>	
	
	
<?php
	echo '<h1>MySQL Testing Using PHP</h1>';
	echo '<h3>Describing Tables in the study_db Database</h3><hr>';

	$hn = 'localhost';
	$db = 'xxx';
	$un = 'thinkpad';
	$pw = 'rambuteau';
	
	/* connect to mysql */
	$conn = new mysqli($hn, $un, $pw, $db);
	
	/* abort if unable to connect */
	if ($conn->connect_error) die('Unable to connect to MySQL:  ' . $conn->connect_error);
	
	/* define sql string */
	$sql1 = "
	select distinct db, table_name, column_name, column_type, index_name, seq_in_index 
	from tsanders.v_describe 
	where db='study_db' and table_name in ('file_actor', 'matrix')
	order by db, table_name, index_name, column_name, seq_in_index
	";
	
	/* execute query */
	$qr1 = $conn->query($sql1);
	$rows1 = $qr1->num_rows;

	echo '<table>';
	echo '<tr style="font-weight: bold;">
		    <td>database</td>
		    <td>column_type</td>
		    <td>table_name</td>
		    <td>index_name</td>
		    <td>column_name</td>
		    <td>seq_in_index</td>
		</tr>';
	
	/* display results in an html table */
	for ($i = 0; $i < $rows1; ++$i)
	{
		echo '<tr>';

		$row = $qr1->fetch_array(MYSQLI_ASSOC);
		echo  '<td>' . $row['db'] 			. '</td>'
			. '<td>' . $row['column_type'] 	. '</td>'
			. '<td>' . $row['table_name'] 	. '</td>'
			. '<td>' . $row['index_name'] 	. '</td>'			
			. '<td>' . $row['column_name'] 	. '</td>'			
			. '<td>' . $row['seq_in_index'] . '</td>'			
		;
		
	}
	echo '</table><hr>';

	/* close connections */
	$qr1->close();
	$conn->close();	
?>
</body>
</html>