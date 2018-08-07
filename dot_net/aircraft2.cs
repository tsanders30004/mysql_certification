using System;
using System.Data;
using MySql.Data;
using MySql.Data.MySqlClient;
public class Example1
{
	public static void Main(string[] args)
		{
			string my_login_parameters = "server=localhost;user=thinkpad;database=aircraft;port=3306;password=rambuteau";
			MySqlConnection my_connection = new MySqlConnection(my_login_parameters);
					MySqlConnection my_connection_scalar = new MySqlConnection(my_login_parameters);
		
			try
			{
				Console.WriteLine("Connecting to MySQL...\n\n");
				my_connection.Open();
				
				Console.WriteLine("deleting row(s) via ExecuteNonQuery\n\n");	
				string my_sql_delete = "delete from aircraft where id >= 66";
				MySqlCommand my_command_delete  = new MySqlCommand(my_sql_delete, my_connection);
				my_command_delete.ExecuteNonQuery();
				
				Console.WriteLine("inserting a row via ExecuteNonQuery\n\n");	
				string my_sql_insert = "insert into aircraft(manf_id, aircraft, num_engines, country_id) values(6, 'A-220', 2, 2)";
				MySqlCommand my_command_insert = new MySqlCommand(my_sql_insert, my_connection);
				my_command_insert.ExecuteNonQuery();	
				
				Console.WriteLine("selecting rows via ExecuteReader\n\n");	
				string my_sql_select = "select manf, aircraft, country from v_aircraft_summary order by rand() limit 10";
				MySqlCommand my_command_select = new MySqlCommand(my_sql_select, my_connection);
				MySqlDataReader my_reader_select = my_command_select.ExecuteReader();
				
				while (my_reader_select.Read())
				{
					Console.WriteLine(my_reader_select[0] + " | " + my_reader_select[1] + " | " + my_reader_select[2]);
				}

			}
			catch (Exception ex)
			{
				Console.WriteLine("Unable to connect to MySQL.");
				Console.WriteLine(ex.ToString());
			}
			my_connection.Close();
		
			try{
				Console.WriteLine("showing current timestamp via ExecuteScalar\n\n");
				string my_sql_scalar = "select current_timestamp";
				MySqlCommand my_command_scalar = new MySqlCommand(my_sql_scalar, my_connection_scalar);
				object my_scalar = my_command_scalar.ExecuteScalar();
                if (my_scalar != null)
                {
                    Console.WriteLine(my_scalar);
                }
			}
			catch (Exception ex)
			{
				Console.WriteLine("Unable to connect to MySQL.");
				Console.WriteLine(ex.ToString());
			}
			my_connection_scalar.Close();
			
			

			Console.WriteLine("Done.");
	}
}
