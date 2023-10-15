namespace employee_registration.Models
{
    public class SaveEmployeeRequest
    {
        public string StoredProcedure { get; set; }
        public string EmployeeName { get; set; }
        public int SectorID { get; set; }
    }
}
