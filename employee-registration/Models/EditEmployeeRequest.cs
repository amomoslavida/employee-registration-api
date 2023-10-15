namespace employee_registration.Models
{
    public class EditEmployeeRequest
    {
        public int employeeID { get; set; }
        public string NewEmployeeName { get; set; }
        public int NewSectorID { get; set; }
    }
}
