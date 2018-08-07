using System;
using System.Data;
using MySql.Data;
using MySql.Data.MySqlClient;

public class Example1
{
     public static void Main(string[] args)
     {

          string my_connection_str = "server=localhost;user=mint;database=aircraft;port=3306;password=rambuteau";
          MySqlConnection my_connection = new MySqlConnection(my_connection_str);

          /* select example via ExecuteNonQuery() */
          try
          {
               Console.WriteLine("inserting row via ExecuteNonQuery");
               my_connection.Open();
               string my_sql_insert = "insert into aircraft values(NULL, 'Boeing', @new_model, NULL)";

               MySqlCommand my_command_insert = new MySqlCommand(my_sql_insert, my_connection);

               Console.WriteLine("enter new model");
               string new_model = Console.ReadLine();
               Console.WriteLine("entering new model " + new_model);

               my_command_insert.Parameters.AddWithValue("@new_model", new_model);

               my_command_insert.ExecuteNonQuery();
               my_connection.Close();
          }
          catch (Exception my_insert_exception)
          {
               Console.WriteLine("mysql error on insert");
               Console.WriteLine(my_insert_exception.ToString());
          }

          /* delete example via ExecuteNonQuery */
          try
          {
               Console.WriteLine("deleting row via ExecuteNonQuery");
               my_connection.Open();
               string my_sql_delete = "delete from aircraft where id=29";
               MySqlCommand my_command_delete = new MySqlCommand(my_sql_delete, my_connection);
               my_command_delete.ExecuteNonQuery();
               my_connection.Close();
          }
          catch (Exception my_delete_exception)
          {
               Console.WriteLine("mysql error on delete");
               Console.WriteLine(my_delete_exception.ToString());
          }

          /* reader example */
          try
          {
               Console.WriteLine("show result set via ExecuteReader");
               my_connection.Open();
               string my_sql_select = "select manf, model, ts from aircraft order by model";
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
               Console.WriteLine("mysql error on select");
               Console.WriteLine(my_select_exception.ToString());
          }

          try
          {
               Console.WriteLine("retrieving number of rows via ExecuteScalar");
               my_connection.Open();
               string my_sql_scalar = "select count(*) from aircraft";
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
               Console.WriteLine("mysql error on scalar");
               Console.WriteLine(my_scalar_exception.ToString());
          }

          Console.WriteLine("done.  mysql closed.");
     }
}