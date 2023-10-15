using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System.Data.SqlClient;
using System.Text;
using System.Data;
using System.Threading.Tasks;
using employee_registration.Interfaces;
using employee_registration.Models;
using employee_registration.Repository;

var builder = WebApplication.CreateBuilder(args);
const string connectionString = "Server=localhost,1433;Database=EmployeeDB;User Id=sa;Password=1141Bafa1141@@;TrustServerCertificate=true;";
builder.Services.AddSingleton(connectionString);
builder.Services.AddSingleton<IEmployeeRepository, EmployeeRepository>();
builder.Services.AddCors();

var app = builder.Build();

// Middleware registrations
app.UseHttpsRedirection();
app.UseCors(policy =>
{
    policy.AllowAnyOrigin()
          .AllowAnyHeader()
          .AllowAnyMethod();
});
app.UseRouting();

app.MapPost("/SaveEmployee", async (SaveEmployeeRequest request, IEmployeeRepository repo) =>
{
    await repo.SaveEmployeeAsync(request);
    return Results.Ok("Stored procedure executed successfully!");
});

app.MapGet("/FetchAllSectorsAsJson", async (IEmployeeRepository repo) =>
{
    var result = await repo.FetchAllSectorsAsJsonAsync();
    if (string.IsNullOrEmpty(result))
        return Results.NotFound("No data found!");

    return Results.Json(result);
});

app.MapPost("/editEmployee", async (EditEmployeeRequest request, IEmployeeRepository repo) =>
{
    await repo.EditEmployeeAsync(request);
    return Results.Ok("Employee edited successfully!");
});

app.MapGet("/GetEmployeeDetailsAsJSON", async (IEmployeeRepository repo) =>
{
    var result = await repo.GetEmployeeDetailsAsJSONAsync();
    if (string.IsNullOrEmpty(result))
        return Results.NotFound("No data found!");

    return Results.Json(result);
});

app.Run();
