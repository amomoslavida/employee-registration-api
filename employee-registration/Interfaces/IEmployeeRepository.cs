using employee_registration.Models;

namespace employee_registration.Interfaces
{
    public interface IEmployeeRepository
    {
        Task SaveEmployeeAsync(SaveEmployeeRequest request);
        Task<string> FetchAllSectorsAsJsonAsync();
        Task EditEmployeeAsync(EditEmployeeRequest request);
        Task<string> GetEmployeeDetailsAsJSONAsync();
    }

}
