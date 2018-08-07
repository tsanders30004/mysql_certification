using System;
using System.Data;

using MySql.Data;
using MySql.Data.MySqlClient;

public class Example1
{
	public static void Main(string[] args)
		{
			string connStr = "server=localhost;user=thinkpad;database=aircraft;port=3306;password=rambuteau";
			MySqlConnection conn = new MySqlConnection(connStr);
			try
			{
				Console.WriteLine("Connecting to MySQL...\n\n");
				conn.Open();
				
				Console.WriteLine("deleting row(s) via ExecuteNonQuery\n\n");	
				string sql2 = "delete from aircraft where id >= 66";
				MySqlCommand cmd2 = new MySqlCommand(sql2, conn);
				cmd2.ExecuteNonQuery();
				
				Console.WriteLine("inserting a row via ExecuteNonQuery\n\n");	
				string sql = "insert into aircraft(manf_id, aircraft, num_engines, country_id) values(6, 'A-220', 2, 2)";
				MySqlCommand cmd = new MySqlCommand(sql, conn);
				cmd.ExecuteNonQuery();	
				
				Console.WriteLine("selecting rows via ExecuteReader\n\n");	
				string sql3 = "select manf, aircraft, country from v_aircraft_summary order by rand() limit 10";
				MySqlCommand cmd3 = new MySqlCommand(sql3, conn);
				MySqlDataReader rdr3 = cmd3.ExecuteReader();
				
				while (rdr3.Read())
				{
					Console.WriteLine(rdr3[0] + " | " + rdr3[1] + " | " + rdr3[2]);
				}

			}
			catch (Exception ex)
			{
				Console.WriteLine("Unable to connect to MySQL.");
				Console.WriteLine(ex.ToString());
			}
			conn.Close();
			Console.WriteLine("Done.");
	}
}
