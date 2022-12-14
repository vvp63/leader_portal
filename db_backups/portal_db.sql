USE [master]
GO
/****** Object:  Database [testportal]    Script Date: 09.11.2022 11:18:29 ******/
CREATE DATABASE [testportal]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'testportal', FILENAME = N'C:\MSSQL\MSSQL14.MSSQLSERVER\MSSQL\DATA\testportal.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'testportal_log', FILENAME = N'C:\MSSQL\MSSQL14.MSSQLSERVER\MSSQL\DATA\testportal_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [testportal] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [testportal].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [testportal] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [testportal] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [testportal] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [testportal] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [testportal] SET ARITHABORT OFF 
GO
ALTER DATABASE [testportal] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [testportal] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [testportal] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [testportal] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [testportal] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [testportal] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [testportal] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [testportal] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [testportal] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [testportal] SET  DISABLE_BROKER 
GO
ALTER DATABASE [testportal] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [testportal] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [testportal] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [testportal] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [testportal] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [testportal] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [testportal] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [testportal] SET RECOVERY FULL 
GO
ALTER DATABASE [testportal] SET  MULTI_USER 
GO
ALTER DATABASE [testportal] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [testportal] SET DB_CHAINING OFF 
GO
ALTER DATABASE [testportal] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [testportal] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [testportal] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [testportal] SET QUERY_STORE = OFF
GO
USE [testportal]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [testportal]
GO
/****** Object:  Table [dbo].[admins]    Script Date: 09.11.2022 11:18:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admins](
	[id] [int] IDENTITY(20000,1) NOT NULL,
	[login] [nvarchar](100) NULL,
	[level] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hide_person]    Script Date: 09.11.2022 11:18:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hide_person](
	[Id] [uniqueidentifier] NULL,
	[hide] [int] NULL,
	[use_alt] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hide_struct]    Script Date: 09.11.2022 11:18:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hide_struct](
	[id] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[meeting_rooms]    Script Date: 09.11.2022 11:18:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[meeting_rooms](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[level] [int] NULL,
	[places] [int] NULL,
	[beg_time] [int] NULL,
	[end_time] [int] NULL,
	[time_incr] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[meetings]    Script Date: 09.11.2022 11:18:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[meetings](
	[id] [int] IDENTITY(1000,1) NOT NULL,
	[room_id] [int] NULL,
	[time_begin] [int] NULL,
	[intervals_num] [int] NULL,
	[person] [uniqueidentifier] NULL,
	[comment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[upl_docs]    Script Date: 09.11.2022 11:18:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[upl_docs](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[filename] [nvarchar](max) NULL,
	[extention] [nvarchar](50) NULL,
	[date] [datetime] NULL,
	[size] [bigint] NULL,
	[comment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[hide_person] ADD  CONSTRAINT [DF_hide_person_hide]  DEFAULT ((0)) FOR [hide]
GO
ALTER TABLE [dbo].[hide_person] ADD  CONSTRAINT [DF_hide_person_use_alt]  DEFAULT ((0)) FOR [use_alt]
GO
/****** Object:  StoredProcedure [dbo].[AddUpdate_hp]    Script Date: 09.11.2022 11:18:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddUpdate_hp] 
	@id			uniqueidentifier,
	@hide		int,
	@alt		int
AS
BEGIN
	UPDATE hide_person SET hide = @hide, use_alt = @alt WHERE Id = @id
	IF @@ROWCOUNT = 0 
		INSERT INTO hide_person (Id, hide, use_alt) VALUES (@id, @hide, @alt)


END
GO
USE [master]
GO
ALTER DATABASE [testportal] SET  READ_WRITE 
GO
