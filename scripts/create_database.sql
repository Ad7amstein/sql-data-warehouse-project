/*
============================================================
Create Database and Schemas for Data Warehouse
============================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists.
    If it exists, the script drops the existing database before creating a new one.
    Additionally, it creates three schemas within the database: 'bronze', 'sliver', and 'gold'.

WARNING:
    Executing this script will result in the loss of all data in the existing 'DataWarehouse' database.
    Ensure that you have backed up any necessary data before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create Database 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

-- Create Schemas
USE DataWarehouse;
GO

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO