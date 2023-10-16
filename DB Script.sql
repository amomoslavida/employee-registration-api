USE [master]
GO
/****** Object:  Database [EmployeeDB]    Script Date: 10/16/2023 3:56:41 AM ******/
CREATE DATABASE [EmployeeDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'EmployeeDB', FILENAME = N'/var/opt/mssql/data/EmployeeDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'EmployeeDB_log', FILENAME = N'/var/opt/mssql/data/EmployeeDB_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [EmployeeDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [EmployeeDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [EmployeeDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [EmployeeDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [EmployeeDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [EmployeeDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [EmployeeDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [EmployeeDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [EmployeeDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [EmployeeDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [EmployeeDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [EmployeeDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [EmployeeDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [EmployeeDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [EmployeeDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [EmployeeDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [EmployeeDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [EmployeeDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [EmployeeDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [EmployeeDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [EmployeeDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [EmployeeDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [EmployeeDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [EmployeeDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [EmployeeDB] SET RECOVERY FULL 
GO
ALTER DATABASE [EmployeeDB] SET  MULTI_USER 
GO
ALTER DATABASE [EmployeeDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [EmployeeDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [EmployeeDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [EmployeeDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [EmployeeDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [EmployeeDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'EmployeeDB', N'ON'
GO
ALTER DATABASE [EmployeeDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [EmployeeDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [EmployeeDB]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 10/16/2023 3:56:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeName] [nvarchar](255) NOT NULL,
	[SectorID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sectors]    Script Date: 10/16/2023 3:56:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sectors](
	[SectorID] [int] IDENTITY(1,1) NOT NULL,
	[SectorName] [nvarchar](255) NOT NULL,
	[ParentSectorID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SectorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_SectorID] FOREIGN KEY([SectorID])
REFERENCES [dbo].[Sectors] ([SectorID])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_SectorID]
GO
ALTER TABLE [dbo].[Sectors]  WITH CHECK ADD FOREIGN KEY([ParentSectorID])
REFERENCES [dbo].[Sectors] ([SectorID])
GO
/****** Object:  StoredProcedure [dbo].[EditEmployee]    Script Date: 10/16/2023 3:56:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EditEmployee]
    @EmployeeID INT,
    @NewEmployeeName NVARCHAR(255),
    @NewSectorID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if another employee with the same name and sector already exists (excluding the current EmployeeID)
    IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeName = @NewEmployeeName AND SectorID = @NewSectorID AND EmployeeID <> @EmployeeID)
    BEGIN
        RAISERROR('Another employee with the same name and sector already exists.', 16, 1);
        RETURN;
    END

    UPDATE Employees
    SET 
        EmployeeName = @NewEmployeeName,
        SectorID = @NewSectorID
    WHERE EmployeeID = @EmployeeID;
END;
GO
/****** Object:  StoredProcedure [dbo].[FetchAllSectorsAsJson]    Script Date: 10/16/2023 3:56:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FetchAllSectorsAsJson]
AS
BEGIN
    SELECT * 
    FROM Sectors
    FOR JSON AUTO;

    
END;
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeDetailsAsJSON]    Script Date: 10/16/2023 3:56:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeeDetailsAsJSON]
AS
BEGIN
    -- Setting up the No Count to prevent extra message outputs
    SET NOCOUNT ON;

    -- Querying the tables and converting the result to JSON
    SELECT
        E.EmployeeID AS 'EmployeeID',
        E.EmployeeName AS 'EmployeeName',
        S.SectorID AS 'SectorID',
        S.SectorName AS 'SectorName'
    FROM
        [dbo].[Employees] E
    INNER JOIN
        [dbo].[Sectors] S ON E.SectorID = S.SectorID
    FOR JSON PATH;
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertEmployee]    Script Date: 10/16/2023 3:56:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertEmployee]
    @EmployeeName NVARCHAR(255),
    @SectorID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validating the provided SectorID
    IF NOT EXISTS (SELECT 1 FROM Sectors WHERE SectorID = @SectorID)
    BEGIN
        THROW 50000, 'The provided SectorID does not exist in the Sectors table.', 1;
        RETURN;
    END

    -- Checking if an employee with the same name and sector already exists
    IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeName = @EmployeeName AND SectorID = @SectorID)
    BEGIN
        THROW 50001, 'An employee with the same name and sector already exists.', 1;
        RETURN;
    END

    -- Inserting the employee
    INSERT INTO Employees (EmployeeName, SectorID)
    VALUES (@EmployeeName, @SectorID);
    
    -- Returning the ID of the newly created employee
    SELECT SCOPE_IDENTITY() AS NewEmployeeID;
END;
GO
USE [master]
GO
ALTER DATABASE [EmployeeDB] SET  READ_WRITE 
GO
