using System;
using System.Data;

using MySql.Data;
using MySql.Data.MySqlClient;

public class Example1
{
	public static void Main(string[] args)
		{
			string connStr = "server=localhost;user=thinkpad;database=flights;port=3306;password=rambuteau";
			MySqlConnection conn = new MySqlConnection(connStr);
			try
			{
				Console.WriteLine("Connecting to MySQL...");
				conn.Open();

				string sql = "select airport_code, name, city_name, country_name from airports_x order by rand() limit 10";
				MySqlCommand cmd = new MySqlCommand(sql, conn);
				MySqlDataReader rdr = cmd.ExecuteReader();

				while (rdr.Read())
				{
					Console.WriteLine(rdr[0] + " | " + rdr[1]);
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
