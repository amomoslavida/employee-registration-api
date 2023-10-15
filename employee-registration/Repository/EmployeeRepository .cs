using employee_registration.Interfaces;
using employee_registration.Models;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Text;

namespace employee_registration.Repository
{
    public class EmployeeRepository : IEmployeeRepository
    {
        private readonly string _connectionString;

        public EmployeeRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task SaveEmployeeAsync(SaveEmployeeRequest request)
        {
            using SqlConnection connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            using SqlCommand command = new SqlCommand(request.StoredProcedure, connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            if (request.StoredProcedure == "InsertEmployee")
            {
                command.Parameters.Add(new SqlParameter("@EmployeeName", request.EmployeeName));
                command.Parameters.Add(new SqlParameter("@SectorID", request.SectorID));
            }

            await command.ExecuteNonQueryAsync();
        }

        public async Task<string> FetchAllSectorsAsJsonAsync()
        {
            using SqlConnection connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            using SqlCommand command = new SqlCommand("FetchAllSectorsAsJson", connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            StringBuilder result = new StringBuilder();
            using SqlDataReader reader = await command.ExecuteReaderAsync();
            if (reader.HasRows)
            {
                while (await reader.ReadAsync())
                {
                    result.Append(Convert.ToString(reader[0]));
                }
                return result.ToString();
            }
            return null;
        }

        public async Task EditEmployeeAsync(EditEmployeeRequest request)
        {
            using SqlConnection connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            using SqlCommand command = new SqlCommand("EditEmployee", connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            command.Parameters.Add(new SqlParameter("@EmployeeID", request.employeeID));
            command.Parameters.Add(new SqlParameter("@NewEmployeeName", request.NewEmployeeName));
            command.Parameters.Add(new SqlParameter("@NewSectorID", request.NewSectorID));

            await command.ExecuteNonQueryAsync();
        }

        public async Task<string> GetEmployeeDetailsAsJSONAsync()
        {
            using SqlConnection connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            using SqlCommand command = new SqlCommand("GetEmployeeDetailsAsJSON", connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            StringBuilder result = new StringBuilder();
            using SqlDataReader reader = await command.ExecuteReaderAsync();
            if (reader.HasRows)
            {
                while (await reader.ReadAsync())
                {
                    result.Append(Convert.ToString(reader[0]));
                }
                return result.ToString();
            }
            return null;
        }
    }

}
