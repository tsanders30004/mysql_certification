using System;
using System.Data;
using MySql.Data;
using MySql.Data.MySqlClient;

public class Example1
{
     public static void Main(string[] args)
     {
          /* create string with database credentials */
          string my_connection_str = "server=localhost;user=mint;database=aircraft;port=3306;password=mint";

          /* establish the connection */
          MySqlConnection my_connection = new MySqlConnection(my_connection_str);

          /* select example via ExecuteNonQuery() */
          try
          {
               Console.WriteLine("inserting row via ExecuteNonQuery\n");
               my_connection.Open();
               string my_sql_insert = "insert into planes values(NULL, 'Boeing', @new_model, NULL)";

               MySqlCommand my_command_insert = new MySqlCommand(my_sql_insert, my_connection);

               Console.WriteLine("enter new model");
               string new_model = Console.ReadLine();
               Console.WriteLine("\nentering new model " + new_model);

               my_command_insert.Parameters.AddWithValue("@new_model", new_model);

               my_command_insert.ExecuteNonQuery();
               my_connection.Close();
          }
          /* catch (Exception my_insert_exception) <--- that will not work; changed to following */
          catch (MySql.Data.MySqlClient.MySqlException my_insert_exception)
          {
               Console.WriteLine("mysql error on insert\n");
               /* Console.WriteLine(my_insert_exception.ToString()); */

               switch (my_insert_exception.Number)
               {
                    case 1062:
                         Console.WriteLine("MySQL Error " + my_insert_exception.Number);
                         Console.WriteLine("MySQL Error " + my_insert_exception.Message);
                         break;
                    case 1366:
                         Console.WriteLine("MySQL Error " + my_insert_exception.Number);
                         Console.WriteLine("MySQL Error " + my_insert_exception.Message);
                         break;
               }
               my_connection.Close();
          }

          /* delete example via ExecuteNonQuery */
          try
          {
               Console.WriteLine("deleting row via ExecuteNonQuery\n");
               my_connection.Open();
               string my_sql_delete = "delete from planes where id=29";
               MySqlCommand my_command_delete = new MySqlCommand(my_sql_delete, my_connection);
               my_command_delete.ExecuteNonQuery();
               my_connection.Close();
          }
          catch (Exception my_delete_exception)
          {
               Console.WriteLine("mysql error on delete\n");
               Console.WriteLine(my_delete_exception.ToString());
          }

          /* reader example */
          try
          {
               Console.WriteLine("show result set via ExecuteReader\n");
               my_connection.Open();
               string my_sql_select = "select manf, model, ts from planes order by model";
               MySqlCommand my_command_select = new MySqlCommand(my_sql_select, my_connection);
               MySqlDataReader my_result_set = my_command_select.ExecuteReader();
               while(my_result_set.Read())
               {
                    Console.WriteLine(my_result_set[0] + "\t" + " | " + my_result_set[1] + " | " + my_result_set[2]);
               }
               my_connection.Close();
          }
          catch (Exception my_select_exception)
          {
               Console.WriteLine("mysql error on select\n");
               Console.WriteLine(my_select_exception.ToString());
          }

          try
          {
               Console.WriteLine("\nretrieving number of rows via ExecuteScalar\n");
               my_connection.Open();
               string my_sql_scalar = "select count(*) from planes";
               MySqlCommand my_command_scalar = new MySqlCommand(my_sql_scalar, my_connection);
               object scalar_result = my_command_scalar.ExecuteScalar();

               if (scalar_result != null)
               {
                    int n = Convert.ToInt32(scalar_result);
                    Console.WriteLine("number of aircraft = " + n);
               }
               my_connection.Close();
          }
          catch (Exception my_scalar_exception)
          {
               Console.WriteLine("mysql error on scalar\n");
               Console.WriteLine(my_scalar_exception.ToString());
          }

          /* stored procedure */
          try
          {
               Console.WriteLine("\nstored procedure test\n");
               my_connection.Open();

               string my_stored_proc = "show_one_plane";
               MySqlCommand my_command_stored_proc = new MySqlCommand(my_stored_proc, my_connection);
               my_command_stored_proc.CommandType = CommandType.StoredProcedure;

               /* parameter name must match name on input variable as defined in the stored procedure */
               my_command_stored_proc.Parameters.AddWithValue("@plane", "757");

               MySqlDataReader my_stored_proc_reader = my_command_stored_proc.ExecuteReader();

               while (my_stored_proc_reader.Read())
               {
                    Console.WriteLine(my_stored_proc_reader[0] + "\t" + my_stored_proc_reader[1] + "\t" + my_stored_proc_reader[2] + "\t" + my_stored_proc_reader[3]);
               }
               Console.WriteLine("\n");

               my_connection.Close();
          }
          catch
          {
               Console.WriteLine("do something");
          }

          /* prepared statement example */
          my_connection.Open();
          MySqlCommand my_prepared_statement_command = new MySqlCommand();
          my_prepared_statement_command.CommandText = "INSERT INTO planes(manf, model) VALUES (@manf, @model)";
          my_prepared_statement_command.Prepare();
          my_prepared_statement_command.Parameters.AddWithValue("@manf", "Boeing");
          my_prepared_statement_command.Parameters.AddWithValue("@model", "747");
          my_prepared_statement_command.ExecuteNonQuery();
          my_connection.Close();
          /* end of demo */
          Console.WriteLine("done.  mysql closed.\n");
     }
}
